import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/repositories/chat_repository.dart';

class DeleteMyChatUsecase{
  final ChatRepository chatRepository;
  DeleteMyChatUsecase({required this.chatRepository});
  Future<void> call(ChatEntity chat)async{
    return chatRepository.deleteChat(chat);
  }
}