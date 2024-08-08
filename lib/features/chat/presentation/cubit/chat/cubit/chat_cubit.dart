import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_application_10/features/chat/domain/use_cases/delete_my_chat_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/get_my_chat_usecase.dart';

import '../../../../domain/entities/chat_entity.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMyChatUsecase getMyChatUsecase;
  final DeleteMyChatUsecase deleteMyChatUsecase;
  ChatCubit({required this.getMyChatUsecase,required this.deleteMyChatUsecase}) : super(ChatInitial());
  Future<void> getMyChat({required ChatEntity chat})async{
    try{
    emit(ChatLoading());
    final streamResponse=getMyChatUsecase.call(chat);
    streamResponse.listen((chatContacts){
      emit(ChatLoaded(chats: chatContacts));
    });
    }
    on SocketException{
      emit(ChatLoadFailure());
    }
    catch(e){
      emit(ChatLoadFailure());
    }
  }
  Future<void> deleteChat({required ChatEntity chat})async{
    try{
      await deleteMyChatUsecase.call(chat);
    }on SocketException{
      emit(ChatLoadFailure());
    }
    catch(e){
      emit(ChatLoadFailure());
    }
  }
}
