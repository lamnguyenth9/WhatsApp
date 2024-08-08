import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/global/widget/profile_widget.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:timeago/timeago.dart'as time_ago;

class MyStatusPage extends StatefulWidget {
  const MyStatusPage({super.key});

  @override
  State<MyStatusPage> createState() => _MyStatusPageState();
}

class _MyStatusPageState extends State<MyStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Status"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: profileWidget(),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(child: Text(
                  time_ago.format(DateTime.now().subtract(Duration(seconds: DateTime.now().second)))
                )),
                PopupMenuButton(
                  icon:Icon(Icons.more_vert, color: Colors.grey.withOpacity(.5),),
                  color: appBarColor,
                  iconSize: 28,
                  onSelected: (value){},
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: GestureDetector(
                        onTap: (){},
                        child: Text('Delete'),
                      ))
                  ],)
              ],
            )
          ],
        ),
      ),
    );
  }
}
