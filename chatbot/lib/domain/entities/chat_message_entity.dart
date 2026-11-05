// Tailored-specific fields removed: ChatBotSuggestionEntity (wardrobe items), sentItems.
// Generic chatbot message: sessionId for multi-turn context, type for message classification.
import 'chat_sender_type.dart';

class ChatMessageEntity {
  final String sessionId;
  final String type;
  final String message;
  final ChatSenderType senderType;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.sessionId,
    required this.type,
    required this.message,
    required this.senderType,
    required this.timestamp,
  });
}
