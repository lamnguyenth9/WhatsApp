import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';

import '../entities/status_entity.dart';

class GetStatusUsecase{
  final StatusRepository repository;
  GetStatusUsecase({required this.repository});

  Stream<List<StatusEntity>> call(StatusEntity status){
    return repository.getStatuses(status);
  }
}