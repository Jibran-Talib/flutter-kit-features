import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_sender_type.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.sessionId,
    required super.type,
    required super.message,
    required super.senderType,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      sessionId: json['session']?.toString() ??
          json['sessionId']?.toString() ??
          json['session_id']?.toString() ??
          '',
      type: json['type']?.toString() ?? 'text',
      message: json['message']?.toString() ??
          json['content']?.toString() ??
          json['text']?.toString() ??
          '',
      senderType: _parseSenderType(json['senderType'] ?? json['sender_type'] ?? json['role']),
      timestamp: _parseTimestamp(json['timestamp'] ?? json['createdAt'] ?? json['created_at']),
    );
  }

  factory ChatMessageModel.fromCacheJson(Map<String, dynamic> json) {
    return ChatMessageModel.fromJson(json);
  }

  Map<String, dynamic> toCacheJson() {
    return {
      'sessionId': sessionId,
      'type': type,
      'message': message,
      'senderType': senderType.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static ChatSenderType _parseSenderType(dynamic raw) {
    if (raw == null) return ChatSenderType.bot;
    final s = raw.toString().toLowerCase();
    if (s == 'user') return ChatSenderType.user;
    return ChatSenderType.bot;
  }

  static DateTime _parseTimestamp(dynamic raw) {
    if (raw == null) return DateTime.now();
    if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
    return DateTime.now();
  }
}
