import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  final String? username;
  final String? email;
  final String? phoneNumber;
  final bool? isOnline;
  final String? uid;
  final String? status;
  final String? profileUrl;
  UserModel(
      {this.username,
      this.email,
      this.phoneNumber,
      this.isOnline,
      this.uid,
      this.status,
      this.profileUrl}):super(
        username: username,
        email:email,
        phoneNumber: phoneNumber,
        isOnline: isOnline,
        uid: uid,
        status: status,
        profileUrl: profileUrl
      );
      factory UserModel.fromSnapshot(DocumentSnapshot snapshot){
        final snap=snapshot.data()as Map<String,dynamic>;
        return UserModel(
          username: snap['username'],
          email: snap['email'],
          phoneNumber: snap['phoneNumber'],
          isOnline: snap['isOnline'],
          uid: snap['uid'],
          status: snap['status'],
          profileUrl: snap['profileUrl']
        );
      }
      Map<String,dynamic> toDocument()=>{
        "username":username,
        'email':email,
        'phoneNumber':phoneNumber,
        'isOnline':isOnline,
        'uid':uid,
        'status':status,
        'profileUrl':profileUrl
      };
}