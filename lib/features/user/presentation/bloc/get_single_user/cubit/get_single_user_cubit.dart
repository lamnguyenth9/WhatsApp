import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  GetSingleUserCubit({
    required this.getSingleUserUsecase
  }) : super(GetSingleUserInitial());
  Future<void> getSingleUser({required String uid})async{
     emit(GetSingleUserLoading());
     final streamResponse = await getSingleUserUsecase.call(uid);
     streamResponse.listen((users){
      emit(GetSingleUserLoaded(singleUser: users.first));
     });
  }
}
