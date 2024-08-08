import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  final String? senderUid;
  final String? recipientUid;
  final String? senderName;
  final String? recipientName;
  final String? recentTextMessage;
  final Timestamp? createdAt;
  final String? senderProfile;
  final String? recipientProfile;
  final num? totalUnReadMessages;

  ChatModel(
      {this.senderUid,
      this.recipientUid,
      this.senderName,
      this.recipientName,
      this.recentTextMessage,
      this.createdAt,
      this.senderProfile,
      this.recipientProfile,
      this.totalUnReadMessages})
      : super(
            senderUid: senderUid,
            recipientUid: recipientUid,
            senderName: senderName,
            recipientName: recipientName,
            recentTextMessage: recentTextMessage,
            createdAt: createdAt,
            senderProfile: senderProfile,
            totalUnReadMessages: totalUnReadMessages);
  factory ChatModel.fromSnapshot(DocumentSnapshot snapshot) {
    final snap = snapshot.data() as Map<String, dynamic>;
    return ChatModel(
        recentTextMessage: snap['recentTextMessage'],
        createdAt: snap['createdAt'],
        recipientName: snap['recipientName'],
        recipientProfile: snap['recipientProfile'],
        recipientUid: snap['recipientUid'],
        senderName: snap['senderName'],
        senderProfile: snap['senderProfile'],
        senderUid: snap['senderUid'],
        totalUnReadMessages: snap['totalUnReadMessages']);
  }
  Map<String, dynamic> toDocument() => {
        'recentTextMessage': recentTextMessage,
        'createdAt': createdAt,
        'recipientName': recipientName,
        'recipientProfile': recipientProfile,
        'recipientUid': recipientUid,
        'senderName': senderName,
        'senderProfile': senderProfile,
        'senderUid': senderUid,
        'totalUnReadMessages': totalUnReadMessages
      };
}
