import 'package:fpdart/fpdart.dart';
import '../../core/api_service/api_handler.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../../domain/usecases/send_message_params.dart';
import '../datasources/chatbot_remote_datasource.dart';

class ChatBotRepositoryImpl implements ChatBotRepository {
  final ChatBotRemoteDataSource _remote;

  ChatBotRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> sendMessage(SendMessageParams params) =>
      executeApiRequest(() async {
        final models = await _remote.sendMessage(params);
        return models;
      });
}
