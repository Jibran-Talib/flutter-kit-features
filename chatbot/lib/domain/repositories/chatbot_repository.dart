import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entities/chat_message_entity.dart';
import '../usecases/send_message_params.dart';

abstract class ChatBotRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> sendMessage(SendMessageParams params);
}
