import '../../domain/usecases/send_message_params.dart';

abstract class ChatBotEvent {
  const ChatBotEvent();
}

class LoadInitialChatEvent extends ChatBotEvent {
  const LoadInitialChatEvent();
}

class SendMessageEvent extends ChatBotEvent {
  final SendMessageParams params;
  const SendMessageEvent(this.params);
}

class ClearChatEvent extends ChatBotEvent {
  const ClearChatEvent();
}
