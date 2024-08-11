import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/features/app/const/firebase_collection_const.dart';
import 'package:flutter_application_10/features/app/const/message_type_const.dart';
import 'package:flutter_application_10/features/chat/data/model/chat_model.dart';
import 'package:flutter_application_10/features/chat/data/model/message_model.dart';
import 'package:flutter_application_10/features/chat/data/remote/chat_remote_data_source.dart';
import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:uuid/uuid.dart';

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    
    await sendMessageBasedOnType(message);
    String recentTextMessage="";
    switch(message.messageType){
      case MessageTypeConst.photoMessage:
         recentTextMessage='📷photo';
         break;
      case MessageTypeConst.videoMessage:
         recentTextMessage='📸 Video';
         break;
      case MessageTypeConst.audioMessage:
         recentTextMessage="🎵 Audio";
         break;
      case MessageTypeConst.giftMessage:
         recentTextMessage="Gif";
         break;
      default:
         recentTextMessage=message.message!;
    }


    await addToChat(ChatEntity(
      createdAt: chat.createdAt,
      recentTextMessage: recentTextMessage,
      recipientName: chat.recipientName,
      recipientProfile: chat.recipientProfile,
      recipientUid: chat.recipientUid,
      senderName: chat.senderName,
      senderProfile: chat.senderProfile,
      senderUid: chat.senderUid,
      totalUnReadMessages: chat.totalUnReadMessages
    ));
  }

  Future<void> addToChat(ChatEntity chat) async {
    final myChatRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(chat.senderUid)
        .collection(FirebaseCollectionConst.myChat);

    final otherChatRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(chat.recipientUid)
        .collection(FirebaseCollectionConst.myChat);

    final myNewChat = ChatModel(
            createdAt: chat.createdAt,
            recentTextMessage: chat.recentTextMessage,
            recipientName: chat.recipientName,
            recipientProfile: chat.recipientProfile,
            recipientUid: chat.recipientUid,
            senderName: chat.senderName,
            senderProfile: chat.senderProfile,
            senderUid: chat.senderUid,
            totalUnReadMessages: chat.totalUnReadMessages)
        .toDocument();
    final otherNewChat = ChatModel(
      createdAt: chat.createdAt,
      recentTextMessage: chat.recentTextMessage,
      recipientName: chat.senderName,
      recipientProfile: chat.senderProfile,
      recipientUid: chat.senderUid,
      senderName: chat.recipientName,
      senderProfile: chat.recipientProfile,
      senderUid: chat.recipientUid,
      totalUnReadMessages: chat.totalUnReadMessages,
    ).toDocument();
    try {
      myChatRef.doc(chat.recipientUid).get().then((myChatDoc) async {
        if (!myChatDoc.exists) {
          await myChatRef.doc(chat.recipientUid).set(myNewChat);
          await otherChatRef.doc(chat.senderUid).set(otherNewChat);
          return;
        } else {
          await myChatRef.doc(chat.recipientUid).update(myNewChat);
          await otherChatRef.doc(chat.senderUid).update(otherNewChat);
          return;
        }
      });
    } catch (e) {
      print("Something error occurr while adding chat");
    }
  }

  Future<void> sendMessageBasedOnType(MessageEntity message) async {
    final myMessageRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.messages);
    final otherMessageRef = firestore
        .collection(FirebaseCollectionConst.users)
        .doc(message.recipientUid)
        .collection(FirebaseCollectionConst.myChat)
        .doc(message.senderUid)
        .collection(FirebaseCollectionConst.messages);
    String messageId = const Uuid().v1();
    final newMessage = MessageModel(
        createdAt: message.createdAt,
        isSeen: message.isSeen,
        message: message.message,
        messageId: messageId,
        messageType: message.messageType,
        recipientName: message.recipientName,
        recipientUid: message.recipientUid,
        repliedMessage: message.repliedMessage,
        repliedMessageType: message.repliedMessageType,
        repliedTo: message.repliedTo,
        senderName: message.senderName,
        senderUid: message.senderUid).toDocument();
        try{
          await myMessageRef.doc(messageId).set(newMessage);
          await otherMessageRef.doc(messageId).set(newMessage);
        }catch(e){
          print("Something went wrong");
        }
  }

  @override
  Future<void> deleteChat(ChatEntity chat)async {
    final chatRef = firestore
    .collection(FirebaseCollectionConst.users)
    .doc(chat.senderUid)
    .collection(FirebaseCollectionConst.myChat)
    .doc(chat.recipientUid);
    try{
      await chatRef.delete();
    }catch(e){
      print("Something went wrong");
    }
  }

  @override
  Future<void> deleteMessage(MessageEntity message) async{
    final messageRef = firestore
    .collection(FirebaseCollectionConst.users)
    .doc(message.senderUid)
    .collection(FirebaseCollectionConst.myChat)
    .doc(message.recipientUid)
    .collection(FirebaseCollectionConst.messages)
    .doc(message.messageId);
    try{
      await messageRef.delete();
      print(messageRef.id);
    }catch(e){
      print("Something went wrong");
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) {
    final messageRef =firestore
          .collection(FirebaseCollectionConst.users)
          .doc(message.senderUid)
          .collection(FirebaseCollectionConst.myChat)
          .doc(message.recipientUid)
          .collection(FirebaseCollectionConst.messages)
          .orderBy("createdAt",descending: false);
    return messageRef.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>MessageModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) {
     final myChatRef =firestore
          .collection(FirebaseCollectionConst.users)
          .doc(chat.senderUid)
          .collection(FirebaseCollectionConst.myChat)
          .orderBy("createdAt",descending: true);
          return myChatRef.snapshots().map((querySnapshot)=>querySnapshot.docs.map((e)=>ChatModel.fromSnapshot(e)).toList());
  }
}
