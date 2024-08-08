import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/app/global/widget/profile_widget.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:intl/intl.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: profileWidget(),
                    ),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 8,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            color: tabColor,
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(width: 2, color: backgroundColor)),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 20,
                          ),
                        ),
                      ))
                ],
              ),
              const Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Status",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Tap to add your status update",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              )),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, PageConst.myStatusPage);
                },
                  child: Icon(
                Icons.more_horiz,
                color: Colors.grey.withOpacity(0.5),
              )),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              "recents update",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  height: 55,
                  width: 55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: profileWidget(),
                  ),
                ),
                title: const Text("User name"),
                subtitle: Text(
                  DateFormat.jm().format(DateTime.now()),
                  style: const TextStyle(color: greyColor, fontSize: 13),
                ),
              );
            },
          )
        ],
      ),
    ));
  }
}
