// Tailored-specific removed: pendingSuggestionItems (wardrobe), _latestSuggestionItems(), items in SendMessageParams.
// Generic: session-aware multi-turn chatbot with local caching via StorageService.
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/chat_message_model.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_sender_type.dart';
import '../../domain/usecases/send_message_params.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_bot_event.dart';
import 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  // TODO: customize the initial prompt for your app
  static const String initialPrompt = 'Hello, I need help';

  final SendMessageUseCase _sendMessageUseCase;
  final StorageService _storageService;
  final String _userId;

  ChatBotBloc({
    required SendMessageUseCase sendMessageUseCase,
    required StorageService storageService,
    required String userId,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _storageService = storageService,
        _userId = userId,
        super(ChatBotState.initial()) {
    on<LoadInitialChatEvent>(_onLoadInitialChat);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatBotState> emit,
  ) async {
    final message = event.params.message.trim();
    final userMessage = ChatMessageEntity(
      sessionId: state.sessionId ?? '',
      type: 'text',
      message: message,
      senderType: ChatSenderType.user,
      timestamp: DateTime.now(),
    );
    final messagesWithUser = [...state.messages, userMessage];

    emit(state.copyWith(
      messages: messagesWithUser,
      status: ChatBotStatus.loading,
      isTyping: true,
      clearError: true,
    ));

    try {
      final requestParams = event.params.copyWith(
        message: message,
        session: state.sessionId,
      );

      final result = await _sendMessageUseCase(requestParams);

      result.fold(
        (failure) {
          log('ChatBot error: ${failure.message}');
          emit(state.copyWith(
            messages: messagesWithUser,
            status: ChatBotStatus.error,
            error: failure.message,
            isTyping: false,
          ));
          _saveState(state.copyWith(messages: messagesWithUser));
        },
        (botMessages) {
          final latestSession = _latestSessionId(botMessages) ?? state.sessionId;
          final nextState = state.copyWith(
            messages: [...messagesWithUser, ...botMessages],
            sessionId: latestSession,
            status: ChatBotStatus.loaded,
            isTyping: false,
            clearError: true,
          );
          emit(nextState);
          _saveState(nextState);
        },
      );
    } catch (e) {
      log('ChatBot exception: $e');
      emit(state.copyWith(
        messages: messagesWithUser,
        status: ChatBotStatus.error,
        error: 'An error occurred: $e',
        isTyping: false,
      ));
    }
  }

  Future<void> _onLoadInitialChat(
    LoadInitialChatEvent event,
    Emitter<ChatBotState> emit,
  ) async {
    if (state.messages.isNotEmpty || state.status == ChatBotStatus.loading) return;

    final cachedState = _loadCachedState();
    if (cachedState != null && cachedState.messages.isNotEmpty) {
      emit(cachedState.copyWith(status: ChatBotStatus.loaded, isTyping: false));
      return;
    }

    emit(state.copyWith(status: ChatBotStatus.loading, isTyping: true, clearError: true));

    final result = await _sendMessageUseCase(const SendMessageParams(message: initialPrompt));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatBotStatus.error,
        error: failure.message,
        isTyping: false,
      )),
      (botMessages) {
        final latestSession = _latestSessionId(botMessages) ?? state.sessionId;
        final nextState = state.copyWith(
          messages: botMessages,
          sessionId: latestSession,
          status: ChatBotStatus.loaded,
          isTyping: false,
          clearError: true,
        );
        emit(nextState);
        _saveState(nextState);
      },
    );
  }

  Future<void> _onClearChat(ClearChatEvent event, Emitter<ChatBotState> emit) async {
    emit(ChatBotState.initial());
    try {
      await _storageService.removeChatBotState(_userId);
    } catch (e) {
      log('Error clearing chat: $e');
    }
  }

  ChatBotState? _loadCachedState() {
    final cached = _storageService.getChatBotState(_userId);
    if (cached == null) return null;
    final rawMessages = cached['messages'];
    return ChatBotState(
      messages: rawMessages is List
          ? rawMessages
              .whereType<Map>()
              .map((item) => ChatMessageModel.fromCacheJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      status: ChatBotStatus.loaded,
      isTyping: false,
      sessionId: cached['sessionId']?.toString(),
    );
  }

  Future<void> _saveState(ChatBotState chatState) {
    final messages = chatState.messages
        .map((m) => ChatMessageModel(
              sessionId: m.sessionId,
              type: m.type,
              message: m.message,
              senderType: m.senderType,
              timestamp: m.timestamp,
            ).toCacheJson())
        .toList();

    return _storageService.saveChatBotState(_userId, {
      'messages': messages,
      'sessionId': chatState.sessionId,
    });
  }

  String? _latestSessionId(List<ChatMessageEntity> messages) {
    for (final m in messages.reversed) {
      if (m.sessionId.trim().isNotEmpty) return m.sessionId.trim();
    }
    return null;
  }
}
