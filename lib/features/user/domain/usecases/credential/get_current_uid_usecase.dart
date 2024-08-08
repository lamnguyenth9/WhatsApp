import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

class GetCurrentUidUsecase{
  final UserRepository userRepository;
  GetCurrentUidUsecase({required this.userRepository});
  Future<String> call()async{
    return userRepository.getCurrentUID();
  }
}