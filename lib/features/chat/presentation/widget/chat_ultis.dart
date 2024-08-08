import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/message/cubit/message_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_entity.dart';

class ChatUltis{
  static Future<void> sendMessage(BuildContext context,{
    required MessageEntity messageEntity,
    String? message,
    String? type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType
  })async{
    BlocProvider.of<MessageCubit>(context).sendMessage(
      message: MessageEntity(
          senderName: messageEntity.senderName,
          senderUid:  messageEntity.senderUid,
          recipientName:  messageEntity.recipientName,
          recipientUid:  messageEntity.recipientUid,
          createdAt: Timestamp.now(),
          isSeen: false,
          message: message,
          messageType: type,
          repliedTo:repliedTo?? "",
          repliedMessageType:repliedMessageType?? "",
          repliedMessage:repliedMessage?? "",
        ),
      chat: ChatEntity(
            senderName: messageEntity.senderName,
            senderProfile: messageEntity.senderProfile,
            senderUid: messageEntity.senderUid,
            recipientName: messageEntity.recipientName,
            recipientProfile: messageEntity.recipientProfile,
            recipientUid: messageEntity.recipientUid,
            createdAt: Timestamp.now(),
            totalUnReadMessages: 0)
            );
  }
}