import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_10/features/app/const/app_const.dart';
import 'package:flutter_application_10/features/app/const/firebase_collection_const.dart';
import 'package:flutter_application_10/features/user/data/data_source/remote/user_remote_data_source.dart';
import 'package:flutter_application_10/features/user/data/model/user_model.dart';
import 'package:flutter_application_10/features/user/domain/entities/contact_entity.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  String _verificationId = "";
  UserRemoteDataSourceImpl(
      {required this.firestore, required this.firebaseAuth});
  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firestore.collection(FirebaseCollectionConst.users);
    final uid = await getCurrentUID();
    final newUser = UserModel(
            email: user.email,
            isOnline: user.isOnline,
            phoneNumber: user.phoneNumber,
            profileUrl: user.profileUrl,
            status: user.status,
            uid: uid,
            username: user.username)
        .toDocument();
    try {
      userCollection.doc(uid).get().then((userDoc) {
        if (!userDoc.exists) {
          userCollection.doc(uid).set(newUser);
        } else {
          userCollection.doc(uid).update(newUser);
        }
      });
    } catch (e) {
      throw Exception("Some Error occurr while create user");
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = firestore.collection(FirebaseCollectionConst.users);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<String> getCurrentUID() async => firebaseAuth.currentUser!.uid;

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    List<ContactEntity> contactsList = [];

    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      for (var contact in contacts) {
        contactsList.add(ContactEntity(
            name: contact.name, photo: contact.photo, phones: contact.phones));
      }
    }

    return contactsList;
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firestore
        .collection(FirebaseCollectionConst.users)
        .where("uid", isEqualTo: uid);
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsPinCode);
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        toast("Invalid verification Code");
      } else if (e.code == "qouta-exceeded") {
        toast("SMS qouta-exceeded");
      }
    } catch (e) {
      toast("Unknow Exception please try again");
    }
  }

  @override
  Future<void> signOut() async => firebaseAuth.signOut();

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firestore.collection(FirebaseCollectionConst.users);
    Map<String, dynamic> userInfor = {};
    if (user.username != "" && user.username != null) {
      userInfor['usernamwe'] = user.username;
    }
    if (user.status != "" && user.status != null) {
      userInfor['status'] = user.status;
    }
    if (user.profileUrl != "" && user.profileUrl != null) {
      userInfor['profileUrl'] = user.profileUrl;
    }
    if (user.isOnline != null) {
      userInfor['isOnline'] = user.isOnline;
    }
    userCollection.doc(user.uid).update(userInfor);
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    verificationCompleted(AuthCredential authCredential) {
      print(
          "phone verified: Token ${authCredential.token} ${authCredential.signInMethod}");
    }

    verificationFailed(FirebaseAuthException exception) {
      print("Phone failed1: ${exception.message} ${exception.code}");
    }

    codeSent(String verificationId, int? forceResendingToken) {
      _verificationId = verificationId;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      print("Time out: $verificationId");
    }

    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
