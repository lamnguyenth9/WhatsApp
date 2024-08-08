import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class SignOutUsecase{
  final UserRepository userRepository;
  SignOutUsecase({required this.userRepository});

  Future<void> call() async{
    return userRepository.signOut();
  }
}