import 'core/api_service/network.dart';
import 'core/di/service_locator.dart';
import 'core/services/storage_service.dart';
import 'data/datasources/chatbot_remote_datasource.dart';
import 'data/repositories/chatbot_repository_impl.dart';
import 'domain/repositories/chatbot_repository.dart';
import 'domain/usecases/send_message_usecase.dart';
import 'presentation/bloc/chat_bot_bloc.dart';

void initChatBotInjection() {
  sl.registerLazySingleton<ChatBotRemoteDataSource>(
    () => ChatBotRemoteDataSourceImpl(sl<ApiService>()),
  );

  sl.registerLazySingleton<ChatBotRepository>(
    () => ChatBotRepositoryImpl(sl<ChatBotRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatBotRepository>()));

  // Factory — requires userId, use registerFactoryParam
  sl.registerFactoryParam<ChatBotBloc, String, void>(
    (userId, _) => ChatBotBloc(
      sendMessageUseCase: sl<SendMessageUseCase>(),
      storageService: sl<StorageService>(),
      userId: userId,
    ),
  );
}
