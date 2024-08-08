import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class SignInWithPhoneNumberUsecase{
  final UserRepository userRepository;
  SignInWithPhoneNumberUsecase({required this.userRepository});
  Future<void> call(String smsPinCode) async{
    return userRepository.signInWithPhoneNumber(smsPinCode);
  }
}