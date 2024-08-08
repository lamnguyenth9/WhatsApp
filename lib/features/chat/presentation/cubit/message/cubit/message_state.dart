part of 'message_cubit.dart';

sealed class MessageState extends Equatable {
  const MessageState();
}

final class MessageInitial extends MessageState {
   @override
  List<Object> get props => [];
}
final class MessageLoading extends MessageState {
   @override
  List<Object> get props => [];
}
final class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;
  MessageLoaded({required this.messages});
   @override
  List<Object> get props => [messages];
}
final class MessageLoadingFailure extends MessageState {
   @override
  List<Object> get props => [];
}
