import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class IsSignInUsecase{
  final UserRepository userRepository;
  IsSignInUsecase({required this.userRepository});

  Future<bool> call() async{
    return userRepository.isSignIn();
  }
}