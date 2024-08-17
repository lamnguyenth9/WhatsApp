import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';

class SeenStatusUpdateUsecase{
  final StatusRepository repository;
  SeenStatusUpdateUsecase({required this.repository});

  Future<void> call(String statusId, int imageIndex,String userId)async{
    return await repository.seenStatusUpdate(statusId, imageIndex, userId);
  }
}