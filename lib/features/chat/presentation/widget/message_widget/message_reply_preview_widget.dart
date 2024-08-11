import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/const/message_type_const.dart';
import '../../../../app/theme/style.dart';
import '../../cubit/message/cubit/message_cubit.dart';
import 'message_reply_type_widget.dart';

class MessageReplayPreviewWidget extends StatelessWidget {
  final VoidCallback? onCancelReplayListener;
  const MessageReplayPreviewWidget({Key? key, this.onCancelReplayListener}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final provider = BlocProvider.of<MessageCubit>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: provider.messageReplyEntity.messageType == MessageTypeConst.textMessage? 70 : 100,
      decoration: const BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor.withOpacity(.4)
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 3.5,
              decoration: BoxDecoration(
                color: provider.messageReplyEntity.isMe == true? tabColor : Colors.deepPurpleAccent,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text("${provider.messageReplyEntity.isMe == true? "You" : provider.messageReplyEntity.usename}", style: TextStyle(fontWeight: FontWeight.bold, color: provider.messageReplyEntity.isMe == true? tabColor : Colors.deepPurpleAccent),)),
                        GestureDetector(onTap: onCancelReplayListener, child: const Icon(Icons.close, size: 18, color: Colors.grey,)),
                      ],
                    ),
                    const SizedBox(height: 3,),

                    provider.messageReplyEntity.messageType == MessageTypeConst.textMessage ? Text("${provider.messageReplyEntity.message}", maxLines: 2,style: const TextStyle(fontSize: 12, color: greyColor, overflow: TextOverflow.ellipsis),) : Row(
                      children: [
                        MessageReplayTypeWidget(
                          message: provider.messageReplyEntity.message,
                          type: provider.messageReplyEntity.messageType,
                        ),
                      ],
                    ),
                   // Text("${BlocProvider.of<CommunicationCubit>(context).messageReplay.message}", maxLines: 2,style: TextStyle(fontSize: 12, color: greyColor, overflow: TextOverflow.ellipsis),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}