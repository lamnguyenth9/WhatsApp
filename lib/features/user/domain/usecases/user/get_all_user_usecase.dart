import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

import '../../entities/user_entity.dart';

class GetAllUserUsecase{
  final UserRepository userRepository;
  GetAllUserUsecase({required this.userRepository});
  Stream<List<UserEntity>> call(){

   return userRepository.getAllUsers();
  }
}