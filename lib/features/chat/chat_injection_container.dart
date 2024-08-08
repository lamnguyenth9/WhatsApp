import 'package:flutter_application_10/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:flutter_application_10/features/chat/data/remote/chat_remote_data_source_impl.dart';
import 'package:flutter_application_10/features/chat/data/repository/chat_repositpry_impl.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/delete_message_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/delete_my_chat_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/get_messages_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/get_my_chat_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/send_message_usecase.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/chat/cubit/chat_cubit.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/message/cubit/message_cubit.dart';
import 'package:flutter_application_10/main_injection_container.dart';

Future< void> ChatInjectionContainer()async{
  //*CUBIT
  sl.registerFactory<ChatCubit>(()=>ChatCubit(
    getMyChatUsecase: sl.call(), 
    deleteMyChatUsecase: sl.call()));
   sl.registerFactory<MessageCubit>(()=>MessageCubit(
    deleteMessageUsecase: sl.call(), 
    sendMessageUsecase: sl.call(), 
    getMessagesUsecase: sl.call()));
  //*USECASE
   sl.registerLazySingleton<DeleteMessageUsecase>(()=>DeleteMessageUsecase(chatRepository: sl.call()));
   sl.registerLazySingleton<DeleteMyChatUsecase>(()=>DeleteMyChatUsecase(chatRepository: sl.call()));
   sl.registerLazySingleton<GetMessagesUsecase>(()=>GetMessagesUsecase(chatRepository: sl.call()));
   sl.registerLazySingleton<GetMyChatUsecase>(()=>GetMyChatUsecase(chatRepository: sl.call()));
   sl.registerLazySingleton<SendMessageUsecase>(()=>SendMessageUsecase(chatRepository: sl.call()));
  //*REPOSITORY & DATA SOURCE
  sl.registerLazySingleton<ChatRepository>(()=>ChatRepositpryImpl(chatRemoteDataSource: sl.call()));
  sl.registerLazySingleton<ChatRemoteDataSource>(()=>ChatRemoteDataSourceImpl(firestore: sl.call()));
}