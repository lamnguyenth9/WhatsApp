
import 'package:flutter_application_10/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositpryImpl extends ChatRepository{
  final ChatRemoteDataSource chatRemoteDataSource;
  ChatRepositpryImpl({required this.chatRemoteDataSource});
  @override
  Future<void> deleteChat(ChatEntity chat) async=>chatRemoteDataSource.deleteChat(chat);

  @override
  Future<void> deleteMessage(MessageEntity message) =>chatRemoteDataSource.deleteMessage(message);

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) =>chatRemoteDataSource.getMessages(message);

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) =>chatRemoteDataSource.getMyChat(chat);

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async=>chatRemoteDataSource.sendMessage(chat, message);

}