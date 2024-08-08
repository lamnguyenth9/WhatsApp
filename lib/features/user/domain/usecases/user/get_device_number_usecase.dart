import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';

import '../../entities/contact_entity.dart';

class GetDeviceNumberUsecase{
  final UserRepository userRepository;
  GetDeviceNumberUsecase({required this.userRepository});
  Future<List<ContactEntity>> call() async{
    return userRepository.getDeviceNumber();
  }
}