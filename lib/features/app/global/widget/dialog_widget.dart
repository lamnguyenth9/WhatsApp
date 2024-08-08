

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';

displayAlertDialog(BuildContext context, {required VoidCallback onTap, required String confirmTitle, required String content}){
  Widget cacelButton = TextButton(
    onPressed: (){
      Navigator.pop(context);
    }, 
    child: const Text("Cancel",style: TextStyle(
      color: tabColor
    ),));
    Widget deleteButton = TextButton(
    onPressed: onTap,
    child: Text(confirmTitle, style: const TextStyle(color: tabColor),),
  );
  AlertDialog alert =AlertDialog(
    backgroundColor: backgroundColor,
    content: Text(content),
    actions: [cacelButton,deleteButton  ],
  );
  showDialog(context: context, builder: (context) {
    return alert;
  },);
}