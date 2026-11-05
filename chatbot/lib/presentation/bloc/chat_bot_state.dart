import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

enum ChatBotStatus { initial, loading, loaded, error }

class ChatBotState extends Equatable {
  final List<ChatMessageEntity> messages;
  final ChatBotStatus status;
  final String? error;
  final bool isTyping;
  final String? sessionId;

  const ChatBotState({
    this.messages = const [],
    this.status = ChatBotStatus.initial,
    this.error,
    this.isTyping = false,
    this.sessionId,
  });

  factory ChatBotState.initial() => const ChatBotState();

  ChatBotState copyWith({
    List<ChatMessageEntity>? messages,
    ChatBotStatus? status,
    String? error,
    bool? isTyping,
    String? sessionId,
    bool clearError = false,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      isTyping: isTyping ?? this.isTyping,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  List<Object?> get props => [messages, status, error, isTyping, sessionId];
}
