import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesUsecase{
  final ChatRepository chatRepository;
  GetMessagesUsecase({required this.chatRepository});
  Stream<List<MessageEntity>> call(MessageEntity message){
    return chatRepository.getMessages(message);
  }
}