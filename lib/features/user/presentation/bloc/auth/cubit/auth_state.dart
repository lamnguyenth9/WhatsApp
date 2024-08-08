part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  
}

final class AuthInitial extends AuthState {

  @override
  List<Object> get props => [];
}
class Authticated extends AuthState{
  final String uid;
  Authticated({required this.uid});
  @override
  List<Object> get props => [uid];
}

class UnAuthticated extends AuthState{
  @override
  List<Object?> get props => [];

}