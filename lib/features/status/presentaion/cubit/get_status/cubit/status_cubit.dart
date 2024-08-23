import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/create_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/delete_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/get_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/seen_status_update_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/update_only_image_status_usecase.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/update_status_usecase.dart';

import '../../../../domain/entities/status_entity.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  final CreateStatusUsecase createStatusUsecase;
  final DeleteStatusUsecase deleteStatusUsecase;
  final UpdateStatusUsecase updateStatusUsecase;
  final GetStatusUsecase getStatusUsecase;
  final UpdateOnlyImageStatusUsecase updateOnlyImageStatusUsecase;
  final SeenStatusUpdateUsecase seenStatusUpdateUsecase;
  StatusCubit( 
      {required this.createStatusUsecase,
      required this.deleteStatusUsecase,
      required this.updateStatusUsecase,
      required this.getStatusUsecase,
      required this.updateOnlyImageStatusUsecase,
      required this.seenStatusUpdateUsecase})
      : super(StatusInitial());
  Future<void> getStatus({required StatusEntity status})async{
    try{
     final streamResponse=getStatusUsecase.call(status);
     streamResponse.listen((statuses){
      print("statuses: $statuses");
      emit(StatusLoaded(statuses: statuses));
     });
    }
    on SocketException{
      emit(StatusFailure());
    }
    catch(e){
     emit(StatusFailure());
    }
    
  }
  Future<void> createStatus({required StatusEntity status})async{
     try{
     await createStatusUsecase.call(status);
    }
    on SocketException{
      emit(StatusFailure());
    }
    catch(e){
     emit(StatusFailure());
    }
  }
  Future<void> deleteStatus({required StatusEntity status})async{
     try{
     await deleteStatusUsecase.call(status);
    }
    on SocketException{
      emit(StatusFailure());
    }
    catch(e){
     emit(StatusFailure());
    }
  }
  Future<void> updateStatus({required StatusEntity status})async{
     try{
     await updateStatusUsecase.call(status);
    }
    on SocketException{
      emit(StatusFailure());
    }
    catch(e){
     emit(StatusFailure());
    }
  }
  Future<void> seenStatusUpdate({required String statusId,required int imageIndex, required String userId})async{
     try{
     await seenStatusUpdateUsecase.call(statusId, imageIndex, userId);
    }
    on SocketException{
      emit(StatusFailure());
    }
    catch(e){
     emit(StatusFailure());
    }
  }
  Future<void> updateOnlyImageStatus({required StatusEntity status}) async {

    try {
      await updateOnlyImageStatusUsecase.call(status);

    } on SocketException {
      emit(StatusFailure());
    } catch(_) {
      emit(StatusFailure());
    }
  }
}
