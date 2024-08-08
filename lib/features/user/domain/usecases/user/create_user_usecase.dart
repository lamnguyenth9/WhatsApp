import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class CreateUserUsecase{
  final UserRepository userRepository;
  CreateUserUsecase({required this.userRepository});

  Future<void> call(UserEntity user)async{
    return userRepository.createUser(user);
  }
}