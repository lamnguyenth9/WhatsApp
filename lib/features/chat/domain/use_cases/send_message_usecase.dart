import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUsecase{
  final ChatRepository chatRepository;
  SendMessageUsecase({required this.chatRepository});
  Future<void> call(MessageEntity message, ChatEntity chat)async{
    return await chatRepository.sendMessage(chat, message);
  }
}