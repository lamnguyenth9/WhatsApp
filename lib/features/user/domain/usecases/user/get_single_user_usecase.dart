import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

import '../../entities/user_entity.dart';

class GetSingleUserUsecase{
  final UserRepository userRepository;
  GetSingleUserUsecase({required this.userRepository});
  Stream<List<UserEntity>> call(String uid){
    return userRepository.getSingleUser(uid);
  }
}