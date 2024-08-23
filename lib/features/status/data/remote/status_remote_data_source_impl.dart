import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_10/features/app/const/firebase_collection_const.dart';
import 'package:flutter_application_10/features/status/data/remote/status_remote_data_source.dart';
import 'package:flutter_application_10/features/status/domain/entities/status_entity.dart';
import 'package:flutter_application_10/features/status/domain/entities/status_image_entity.dart';

import '../model/status_model.dart';

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource{

  final FirebaseFirestore firestore;

  StatusRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createStatus(StatusEntity status) async{
    final statusCollection =firestore.collection(FirebaseCollectionConst.status);
    final statusId= statusCollection.doc().id;
    final newStatus=StatusModel(
      caption: status.caption,
      createdAt: status.createdAt,
      imageUrl: status.imageUrl,
      phoneNumber: status.phoneNumber,
      profileUrl: status.profileUrl,
      statusId: statusId,
      stories: status.stories,
      uid: status.uid,
      username: status.username
    ).toDocument();
    final statusDocRef = await statusCollection.doc(statusId).get();
    try{
      if(!statusDocRef.exists){
        statusCollection.doc(statusId).set(newStatus);
      }else{
        return ;
      }
    }catch(e){
       print("Some error occurr when create status");
    }
  }

  @override
  Future<void> deleteStatus(StatusEntity status) async{
     final statusCollection =firestore.collection(FirebaseCollectionConst.status);
     try{
      statusCollection.doc(status.statusId).delete();
     }catch(e){
       print("Some error occurr when delete status");
     }
  }

  @override
  Stream<List<StatusEntity>> getMyStatus(String uid) {
    final statusCollection =firestore.collection(FirebaseCollectionConst.status)
    .where("uid",isEqualTo: uid).limit(1)
    .where("createdAt",isGreaterThan: DateTime.now().subtract(const Duration(hours: 24))  );
    return statusCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StatusModel.fromSnapshot(e))
        .toList());
  }

  @override
  Future<List<StatusEntity>> getStatusFuture(String uid) {
    final statusCollection =firestore.collection(FirebaseCollectionConst.status)
    .where("uid",isEqualTo: uid).limit(1)
    .where("createdAt",isGreaterThan: DateTime.now().subtract(const Duration(hours: 24))  );
    return statusCollection.get().then((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StatusModel.fromSnapshot(e))
        .toList());
  }

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status) {
    final statusCollection =firestore.collection(FirebaseCollectionConst.status)
   
    .where("createdAt",isGreaterThan: DateTime.now().subtract(const Duration(hours: 24))  );
    return statusCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .where((doc) => doc
        .data()['createdAt']
        .toDate()
        .isAfter(DateTime.now().subtract(const Duration(hours: 24))))
        .map((e) => StatusModel.fromSnapshot(e))
        .toList());
  }

  @override
  Future<void> seenStatusUpdate(String statusId, int imageIndex, String userId) async{
    try{
      final statusDocref =firestore.collection(FirebaseCollectionConst.status)
    .doc(statusId);
    final statusDoc=await statusDocref.get();
    final stories=List<Map<String,dynamic>>.from(statusDoc.get('stories'));
    final viewerList = List<String>.from(stories[imageIndex]['viewers']);
    if(!viewerList.contains(userId)){
      viewerList.add(userId);
      stories[imageIndex]['viewers']=viewerList;
      await statusDocref.update({
        'stories':stories
      });
    }
    }catch(e){
      print("error to updating viewer list: $e");
    }
  }

  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async{
    final statusCollection = firestore.collection(FirebaseCollectionConst.status);
    final statusDocRef= await statusCollection.doc(status.statusId).get();  
    try{
      if(statusDocRef.exists){
        final existingStatusData=statusDocRef.data();
        final createdAt=existingStatusData!['createdAt'].toDate();
        if(createdAt.isAfter(DateTime.now().subtract(Duration(hours: 24)))){
          final updateStories=List<StatusImageEntity>.from(existingStatusData['stories'])
          ..addAll(status.stories!);
          await statusCollection.doc(status.statusId).update({
            'stories':updateStories,
            'imageUrl':updateStories[0].url
          });
        }
      }
    }catch(e){

    }
  }

  @override
  Future<void> updateStatus(StatusEntity status) async{
    final statusCollection=firestore
    .collection(FirebaseCollectionConst.status);
    Map<String,dynamic> statusInfor={};
      if(status.imageUrl!=""&&status.imageUrl!=null){
        statusInfor['imageUrl']=status.imageUrl;

      }
      if(status.stories!=null){
        statusInfor['stories']=status.stories;
      }
      statusCollection.doc(status.statusId).update(statusInfor);
  }
  
 

}