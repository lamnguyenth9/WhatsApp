import 'package:flutter_application_10/features/user/data/data_source/remote/user_remote_data_source.dart';
import 'package:flutter_application_10/features/user/data/data_source/remote/user_remote_data_source_impl.dart';
import 'package:flutter_application_10/features/user/data/repository/user_repository_impl.dart';
import 'package:flutter_application_10/features/user/domain/repository/user_repository.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/is_sign_in_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/sign_in_with_phone_number_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/sign_out_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/credential/verify_phone_number_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/get_all_user_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/get_device_number_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/credential/cubit/credential_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_device_number/cubit/get_device_number_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/user/cubit/user_cubit.dart';
import 'package:flutter_application_10/main_injection_container.dart';

Future<void> userInjectionContainer() async {
  // * CUBIT INJECTION
  sl.registerFactory<AuthCubit>(() => AuthCubit(
      getCurrentUidUsecase: sl.call(),
      isSignInUsecase: sl.call(),
      signOutUsecase: sl.call()));
  sl.registerFactory<UserCubit>(()=>UserCubit(updateUserUsecase: sl.call(), getAllUserUsecase: sl.call()));
  sl.registerFactory<GetSingleUserCubit>(
      () => GetSingleUserCubit(getSingleUserUsecase: sl.call()));
  sl.registerFactory<GetDeviceNumberCubit>(()=>GetDeviceNumberCubit(
    getDeviceNumberUsecase: sl.call()));
  sl.registerFactory<CredentialCubit>(()=>CredentialCubit(
    signInWithPhoneNumberUsecase: sl.call(), 
    verifyPhoneNumberUsecase: sl.call(), 
    createUserUsecase: sl.call()));

  //* USE CASE INJECTION
  sl.registerLazySingleton<GetCurrentUidUsecase>(()=>GetCurrentUidUsecase(
    userRepository: sl.call()));
  sl.registerLazySingleton<IsSignInUsecase>(()=>IsSignInUsecase(
    userRepository: sl.call()));
  sl.registerLazySingleton<SignInWithPhoneNumberUsecase>(()=>SignInWithPhoneNumberUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<SignOutUsecase>(()=>SignOutUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<VerifyPhoneNumberUsecase>(()=>VerifyPhoneNumberUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<CreateUserUsecase>(()=>CreateUserUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<GetAllUserUsecase>(()=>GetAllUserUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<GetDeviceNumberUsecase>(()=>GetDeviceNumberUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<GetSingleUserUsecase>(()=>GetSingleUserUsecase(userRepository: sl.call()));
  sl.registerLazySingleton<UpdateUserUsecase>(()=>UpdateUserUsecase(userRepository: sl.call()));
  //* REPOSITORY USECASE
  sl.registerLazySingleton<UserRepository>(()=>UserRepositoryImpl(remoteDataSource: sl.call()));
  sl.registerLazySingleton<UserRemoteDataSource>(()=>UserRemoteDataSourceImpl(
    firestore: sl.call(), 
    firebaseAuth: sl.call()));
}
