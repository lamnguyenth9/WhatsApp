import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_reply_entity.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/delete_message_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/get_messages_usecase.dart';
import 'package:flutter_application_10/features/chat/domain/use_cases/send_message_usecase.dart';

import '../../../../domain/entities/message_entity.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final DeleteMessageUsecase deleteMessageUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final GetMessagesUsecase getMessagesUsecase;

  MessageCubit(
      {required this.deleteMessageUsecase,
      required this.sendMessageUsecase,
      required this.getMessagesUsecase})
      : super(MessageInitial());
      Future<void> getMessage({required MessageEntity message})async{
        try{
           emit(MessageLoading());
           final streamResponse = getMessagesUsecase.call(message);
           streamResponse.listen((messages){
            emit(MessageLoaded(messages: messages));
           });   
        } on SocketException{
           emit(MessageLoadingFailure());
        }catch(e){
           emit(MessageLoadingFailure());
        }
      }
      Future<void> deleteMessage({required MessageEntity message})async{
        try{
          await deleteMessageUsecase.call(message);
        }on SocketException{
           emit(MessageLoadingFailure());
        }catch(e){
           emit(MessageLoadingFailure());
        }
      }
      Future<void> sendMessage({required MessageEntity message,required ChatEntity chat})async{
        try{
          await sendMessageUsecase.call(message, chat);
        }on SocketException{
           emit(MessageLoadingFailure());
        }catch(e){
           emit(MessageLoadingFailure());
        }
      }
      MessageReplyEntity messageReplyEntity = MessageReplyEntity();
      MessageReplyEntity get getMessageReply=>MessageReplyEntity();
      set setMessageReply(MessageReplyEntity messageReply){
        this.messageReplyEntity=messageReply;
      }
}
