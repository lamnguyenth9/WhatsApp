part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();
}

final class ChatInitial extends ChatState {
   @override
  List<Object> get props => [];
}
final class ChatLoading extends ChatState {
   @override
  List<Object> get props => [];
}
final class ChatLoaded extends ChatState {
  final List<ChatEntity> chats;
  ChatLoaded({required this.chats});
   @override
  List<Object> get props => [chats];
}
final class ChatLoadFailure extends ChatState {
   @override
  List<Object> get props => [];
}

