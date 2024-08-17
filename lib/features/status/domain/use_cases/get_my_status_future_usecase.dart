import 'package:flutter_application_10/features/status/domain/entities/status_entity.dart';
import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';

class GetMyStatusFutureUsecase{
  final StatusRepository repository;
  GetMyStatusFutureUsecase({
    required this.repository
  });
  Stream<List<StatusEntity>> call(String uid){
    return repository.getStatusFuture(uid);
  }
}