import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/get_my_status_usecase.dart';

import '../../../../domain/entities/status_entity.dart';

part 'get_my_status_state.dart';

class GetMyStatusCubit extends Cubit<GetMyStatusState> {
  final GetMyStatusUsecase getMyStatusUsecase;

  GetMyStatusCubit({required this.getMyStatusUsecase}) : super(GetMyStatusInitial());
  Future<void> getMyStatus({required String uid})async{
    try{
       emit(GetMyStatusLoading());
       final streamResponse=getMyStatusUsecase.call(uid);
       streamResponse.listen((statuses){
        print("Mystatuses: $statuses");
        if(statuses.isEmpty){
          emit(GetMyStatusLoaded(myStatus: StatusEntity()));
        }else{
          emit(GetMyStatusLoaded(myStatus: statuses.first));
        }
       });
    } on SocketException
    {

    }catch(e){

    }
  }
}
