import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class UpdateUserUsecase{
  final UserRepository userRepository;

  UpdateUserUsecase({required this.userRepository});

  Future<void> call(UserEntity user)async{
    return userRepository.updateUser(user);
  }
}