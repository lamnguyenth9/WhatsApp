import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_10/features/user/domain/usecases/user/get_device_number_usecase.dart';

import '../../../../domain/entities/contact_entity.dart';

part 'get_device_number_state.dart';

class GetDeviceNumberCubit extends Cubit<GetDeviceNumberState> {
  final GetDeviceNumberUsecase getDeviceNumberUsecase;

  GetDeviceNumberCubit({required this.getDeviceNumberUsecase})
      : super(GetDeviceNumberInitial());
      Future<void> getDeviceNumber()async{
        try{
          final contactNumber =await getDeviceNumberUsecase.call();
        emit(GetDeviceNumberLoaded(contacts: contactNumber));
        }catch(e){
          emit(GetDeviceNumberFailure());
        }
      }
}
