import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../../core/usecase/usecase.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chatbot_repository.dart';
import 'send_message_params.dart';

class SendMessageUseCase implements UseCase<List<ChatMessageEntity>, SendMessageParams> {
  final ChatBotRepository _repository;
  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call(SendMessageParams params) =>
      _repository.sendMessage(params);
}
