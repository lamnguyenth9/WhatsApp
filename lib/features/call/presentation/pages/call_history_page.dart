import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/global/date/date_fornats.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';

import '../../../app/global/widget/profile_widget.dart';

class CallHistoryPage extends StatelessWidget {
  const CallHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Recent", 
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500
                ),
              ),),
              SizedBox(height: 5,),
              ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: ScrollPhysics(),
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
            subtitle: Row(
              children: [
                const Icon(
                  Icons.call_made, color: Colors.green, size: 19,
                ),
                SizedBox(width: 10,),
                Text(formatDateTime(DateTime.now()))
              ],
            ),
            trailing: const Icon(
              Icons.call,
              color: tabColor,
            ),
                  );
                },)
          ],
        ),
      )
    );
  }
}