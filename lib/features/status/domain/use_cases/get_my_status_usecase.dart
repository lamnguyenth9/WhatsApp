import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';

import '../entities/status_entity.dart';

class GetMyStatusUsecase{
  final StatusRepository repository;
  GetMyStatusUsecase({required this.repository});
  Stream<List<StatusEntity>> call(String uid){
    return repository.getMyStatus(uid);
  }
}