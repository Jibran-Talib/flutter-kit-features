import '../../core/api_service/network.dart';
import '../models/chat_message_model.dart';
import '../../domain/usecases/send_message_params.dart';
import 'chatbot_endpoints.dart';

abstract class ChatBotRemoteDataSource {
  Future<List<ChatMessageModel>> sendMessage(SendMessageParams params);
}

class ChatBotRemoteDataSourceImpl implements ChatBotRemoteDataSource {
  final ApiService _apiService;

  ChatBotRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ChatMessageModel>> sendMessage(SendMessageParams params) async {
    final response = await _apiService.request(
      endpoint: ChatBotEndpoints.sendMessage,
      method: DioMethod.post,
      data: params.toJson(),
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to send message');
    }

    final data = response.data;

    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => ChatMessageModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (data is Map) {
      return [ChatMessageModel.fromJson(Map<String, dynamic>.from(data))];
    }

    return const [];
  }
}
