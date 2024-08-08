import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';

import '../../../app/global/widget/profile_widget.dart';

class CallContactPage extends StatefulWidget {
  const CallContactPage({super.key});

  @override
  State<CallContactPage> createState() => _CallContactPageState();
}

class _CallContactPageState extends State<CallContactPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Select Contact"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: profileWidget(),
              ),
            ),
            title:const Text("User name") ,
            subtitle: Text("Hey there! I'm using WhatsApp"),
            trailing: Wrap(
              children: [
                Icon(Icons.call,color: tabColor,size: 22,),
                SizedBox(width: 15,),
                Icon(Icons.videocam_rounded, color: tabColor, size: 25,)
              ],
            ),
          );
        },),
    );;
  }
}