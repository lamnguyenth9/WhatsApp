import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class VerifyPhoneNumberUsecase{
  final UserRepository userRepository;
  VerifyPhoneNumberUsecase({required this.userRepository});
  Future<void> call(String phoneNumber)async{
    return userRepository.verifyPhoneNumber(phoneNumber);
  }
}