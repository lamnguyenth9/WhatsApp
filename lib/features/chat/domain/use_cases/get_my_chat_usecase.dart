import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';

class GetMyChatUsecase{
  final ChatRepository chatRepository;
  GetMyChatUsecase({required this.chatRepository});
  Stream<List<ChatEntity>> call(ChatEntity chat){
    return chatRepository.getMyChat(chat);
  }
}