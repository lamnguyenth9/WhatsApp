import 'package:flutter_application_10/features/status/data/remote/status_remote_data_source.dart';
import 'package:flutter_application_10/features/status/domain/entities/status_entity.dart';
import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements StatusRepository{
  final StatusRemoteDataSource statusRemoteDataSource;

  StatusRepositoryImpl({required this.statusRemoteDataSource});
  @override
  Future<void> createStatus(StatusEntity status) async=>statusRemoteDataSource.createStatus(status);

  @override
  Future<void> deleteStatus(StatusEntity status) async=>statusRemoteDataSource.deleteStatus(status);

  @override
  Stream<List<StatusEntity>> getMyStatus(String uid) =>statusRemoteDataSource.getMyStatus(uid);

  @override
  Future<List<StatusEntity>> getStatusFuture(String uid)  =>statusRemoteDataSource.getStatusFuture(uid);

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status)  =>statusRemoteDataSource.getStatuses(status);

  @override
  Future<void> seenStatusUpdate(String statusId, int imageIndex, String userId) async=>statusRemoteDataSource.seenStatusUpdate(statusId, imageIndex, userId);

  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async=>statusRemoteDataSource.updateOnlyImageStatus(status);

  @override
  Future<void> updateStatus(StatusEntity status) async=>statusRemoteDataSource.updateStatus(status);

}