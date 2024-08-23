import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'status_image_entity.dart';

class StatusEntity extends Equatable {
  final String? statusId;
  final String? imageUrl;
  final String? uid;
  final String? username;
  final String? profileUrl;
  final Timestamp? createdAt;
  final String? phoneNumber;
  final String? caption;
  final List<StatusImageEntity>? stories;

  StatusEntity(
      {this.statusId,
      this.imageUrl,
      this.uid,
      this.username,
      this.profileUrl,
      this.createdAt,
      this.phoneNumber,
      this.caption,
      this.stories});

  @override
  // TODO: implement props
  List<Object?> get props => [
        statusId,
        imageUrl,
        uid,
        username,
        profileUrl,
        createdAt,
        phoneNumber,
        caption,
        stories
      ];
}
