import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/get_all_user_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/update_user_usecase.dart';

import '../../../../domain/entities/user_entity.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUsecase updateUserUsecase;
  final GetAllUserUsecase getAllUserUsecase;
  UserCubit(
    {required this.updateUserUsecase,
    required this.getAllUserUsecase}
  ) : super(UserInitial());

  Future<void> getAllUsers() async{
    emit(UserLoading());
    final streamResponse = await getAllUserUsecase.call();
    streamResponse.listen((users){
      emit(UserLoaded(users: users));
    });
  }
  Future<void> updateUser({required UserEntity user}) async{
    try{
      await updateUserUsecase.call(user);
    }catch(e){
      emit(UserFailure());
    }
  }
}
