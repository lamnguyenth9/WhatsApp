import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/is_sign_in_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUsecase getCurrentUidUsecase;
  final IsSignInUsecase isSignInUsecase;
  final SignOutUsecase signOutUsecase;
  AuthCubit({
    required this.getCurrentUidUsecase,
    required this.isSignInUsecase,
    required this.signOutUsecase
  }) : super(AuthInitial());
  Future<void> AppStarted() async{
    try{
      bool isSignIn =await isSignInUsecase.call();
      if(isSignIn){
        final uid = await getCurrentUidUsecase.call();
        emit(Authticated(uid: uid));
      }else{
        emit(UnAuthticated());
      }
    }catch(e){
      emit(UnAuthticated());
    }
  }

  Future<void> loggedIn() async{
    try{
     final uid =await getCurrentUidUsecase.call();
     emit(Authticated(uid: uid));
    }catch(e){
      emit(UnAuthticated());
    }
  }

  Future<void> loggedOut()async{
    try{
      await signOutUsecase.call();
      emit(UnAuthticated());
    }catch(e){
     emit(UnAuthticated());
    }
  }
}
