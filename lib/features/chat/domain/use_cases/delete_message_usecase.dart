import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';

class DeleteMessageUsecase{
  final ChatRepository chatRepository;
  DeleteMessageUsecase({required this.chatRepository});
  Future<void> call(MessageEntity message) async{
    return await chatRepository.deleteMessage(message);
  }
}