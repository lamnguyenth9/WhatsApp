part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();
}

final class CredentialInitial extends CredentialState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class CredentialLoading extends CredentialState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class CredentialSuccess extends CredentialState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class CredentialPhoneAuthSmsCodeReceive extends CredentialState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class CredentialPhoneAuthProfileInfor extends CredentialState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class CredentialFailure extends CredentialState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
