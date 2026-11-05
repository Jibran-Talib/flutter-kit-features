// Tailored-specific fields removed: items (wardrobe items to include in context).
class SendMessageParams {
  final String message;
  final String? session;

  const SendMessageParams({required this.message, this.session});

  bool get isValid => message.trim().isNotEmpty;

  SendMessageParams copyWith({String? message, String? session}) {
    return SendMessageParams(
      message: message ?? this.message,
      session: session ?? this.session,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'message': message.trim()};
    final trimmedSession = session?.trim();
    if (trimmedSession != null && trimmedSession.isNotEmpty) {
      data['session'] = trimmedSession;
    }
    return data;
  }
}
