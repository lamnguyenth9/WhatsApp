import 'package:flutter_application_10/features/status/domain/entities/status_entity.dart';
import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';

class CreateStatusUsecase{
  final StatusRepository repository;
  CreateStatusUsecase({required this.repository});

  Future<void> call(StatusEntity status)async{
    return await repository.createStatus(status);
  } 
}