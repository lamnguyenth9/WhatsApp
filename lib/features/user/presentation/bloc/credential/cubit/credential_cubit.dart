import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/sign_in_with_phone_number_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/verify_phone_number_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/create_user_usecase.dart';

import '../../../../domain/entities/user_entity.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInWithPhoneNumberUsecase signInWithPhoneNumberUsecase;
  final VerifyPhoneNumberUsecase verifyPhoneNumberUsecase;
  final CreateUserUsecase createUserUsecase;
  CredentialCubit({
    required this.signInWithPhoneNumberUsecase,
    required this.verifyPhoneNumberUsecase,
    required this.createUserUsecase
  }) : super(CredentialInitial());
  Future<void> submitVerifyPhoneNumber({required String phoneNumber})async{
    try{
       await verifyPhoneNumberUsecase.call(phoneNumber);
       emit(CredentialPhoneAuthSmsCodeReceive());
    } on SocketException catch(_){
      emit(CredentialFailure());
    }catch(e){
      emit(CredentialFailure());
    }
  }

  Future<void> submitSmsCode({required String smsPinCode})async{
     try{
       await signInWithPhoneNumberUsecase.call(smsPinCode);
       emit(CredentialPhoneAuthProfileInfor());
    } on SocketException catch(_){
      emit(CredentialFailure());
    }catch(e){
      emit(CredentialFailure());
    }
  }

  Future<void> submitProfileInfor({required UserEntity user})async{
       try{
       await createUserUsecase.call(user);
       emit(CredentialSuccess());
    } on SocketException catch(_){
      emit(CredentialFailure());
    }catch(e){
      emit(CredentialFailure());
    }
  }
}
