import 'package:flutter_application_10/features/status/data/remote/status_remote_data_source.dart';
import 'package:flutter_application_10/features/status/data/remote/status_remote_data_source_impl.dart';
import 'package:flutter_application_10/features/status/data/repository/status_repository_impl.dart';
import 'package:flutter_application_10/features/status/domain/repositories/status_repository.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/create_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/delete_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/get_my_status_future_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/get_my_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/get_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/seen_status_update_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/update_only_image_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/update_status_usecase.dart';
import 'package:flutter_application_10/features/status/presentaion/cubit/get_my_status/cubit/get_my_status_cubit.dart';
import 'package:flutter_application_10/features/status/presentaion/cubit/get_status/cubit/status_cubit.dart';
import 'package:flutter_application_10/main_injection_container.dart';

Future<void> statusInjectionContainer() async {
  //*CUBIT INJECTION
  sl.registerFactory<StatusCubit>(() => StatusCubit(
      createStatusUsecase: sl.call(),
      deleteStatusUsecase: sl.call(),
      updateStatusUsecase: sl.call(),
      getStatusUsecase: sl.call(),
      updateOnlyImageStatusUsecase: sl.call(),
      seenStatusUpdateUsecase: sl.call()));
  sl.registerFactory<GetMyStatusCubit>(
      () => GetMyStatusCubit(getMyStatusUsecase: sl.call()));
  //*USE CASE
  sl.registerLazySingleton<CreateStatusUsecase>(
      () => CreateStatusUsecase(repository: sl.call()));
  sl.registerLazySingleton<DeleteStatusUsecase>(
      () => DeleteStatusUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetMyStatusFutureUsecase>(
      () => GetMyStatusFutureUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetMyStatusUsecase>(
      () => GetMyStatusUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetStatusUsecase>(
      () => GetStatusUsecase(repository: sl.call()));
  sl.registerLazySingleton<SeenStatusUpdateUsecase>(
      () => SeenStatusUpdateUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateOnlyImageStatusUsecase>(
      () => UpdateOnlyImageStatusUsecase(repository: sl.call()));
  sl.registerLazySingleton<UpdateStatusUsecase>(
      () => UpdateStatusUsecase(repository: sl.call()));
  // REPOSITPRY &DATA REMOTE
  sl.registerLazySingleton<StatusRepository>(
      () => StatusRepositoryImpl(statusRemoteDataSource: sl.call()));
  sl.registerLazySingleton<StatusRemoteDataSource>(
      () => StatusRemoteDataSourceImpl(firestore: sl.call()));
}
