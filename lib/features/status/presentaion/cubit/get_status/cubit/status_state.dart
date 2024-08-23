part of 'status_cubit.dart';

sealed class StatusState extends Equatable {
  const StatusState();
}

final class StatusInitial extends StatusState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
final class StatusLoading extends StatusState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
final class StatusLoaded extends StatusState {
  final List<StatusEntity> statuses;
  StatusLoaded({required this.statuses});
  @override
  // TODO: implement props
  List<Object?> get props =>[statuses];
}
final class StatusFailure extends StatusState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
