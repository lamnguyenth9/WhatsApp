import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/app/global/widget/profile_widget.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/chat/cubit/chat_cubit.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  const ChatPage({super.key, required this.uid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getMyChat(chat: ChatEntity(senderUid: widget.uid));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:BlocBuilder<ChatCubit,ChatState>(
        builder: (context, state) {
          
          if(state is ChatLoaded){
            final myChat=state.chats;
            if(myChat.isEmpty){
              return const Center(
                child: Text("No Conversation Yes"),
              );
            }
            return ListView.builder(
            itemCount: myChat.length,
            itemBuilder: (context, index) {
              final chat=myChat[index];
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, PageConst.singleChatPage,
                  arguments: MessageEntity(
                    senderName: chat.senderName,
                    senderUid: chat.senderUid,
                    senderProfile: chat.senderProfile,
                    recipientName: chat.recipientName,
                    recipientProfile: chat.recipientProfile,
                    recipientUid: chat.recipientUid,
                    uid: widget.uid
                  
                  ));
                },
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: profileWidget(),
                    ),
                  ),
                  title: Text("${chat.recipientName}") ,
                  subtitle: Text("${chat.recentTextMessage}",maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: Text(
                    DateFormat.jm().format(chat.createdAt!.toDate() ),
                    style: const TextStyle(
                      color: greyColor,
                      fontSize: 13
                    ),
                  ),
                ),
              );
            },);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}