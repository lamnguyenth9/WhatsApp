import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/app/global/widget/dialog_widget.dart';
import 'package:flutter_application_10/features/app/global/widget/profile_widget.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  final String uid;
  const SettingsPage({super.key, required this.uid});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
              builder: (context, state) {
                if(state is GetSingleUserLoaded){
                  final singleUser = state.singleUser;
                  return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.editProfilePage,arguments: singleUser);
                      },
                      child: SizedBox(
                        height: 65,
                        width: 65,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.5),
                          child: profileWidget(imageUrl: singleUser.profileUrl),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${singleUser.username}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "${singleUser.status}",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )),
                    Icon(
                      Icons.qr_code_sharp,
                      color: tabColor,
                    )
                  ],
                );
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.editProfilePage);
                      },
                      child: SizedBox(
                        height: 65,
                        width: 65,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.5),
                          child: profileWidget(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "....",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "....",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )),
                    Icon(
                      Icons.qr_code_sharp,
                      color: tabColor,
                    )
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colors.grey.withOpacity(.4),
          ),
          const SizedBox(
            height: 10,
          ),
          _settingItemWidget(
              title: "Account",
              description: "Security applications, change number",
              icon: Icons.key,
              onTap: () {}),
          _settingItemWidget(
              title: "Privacy",
              description: "Block contacts, disappearing messages",
              icon: Icons.lock,
              onTap: () {}),
          _settingItemWidget(
              title: "Chats",
              description: "Theme, wallpapers, chat history",
              icon: Icons.message,
              onTap: () {}),
          _settingItemWidget(
              title: "Log out",
              description: "Logout from WhatsApp Clone",
              icon: Icons.exit_to_app,
              onTap: () {
                displayAlertDialog(
                  context, 
                  onTap: (){
                    BlocProvider.of<AuthCubit>(context).loggedOut();
                    Navigator.pushNamedAndRemoveUntil(context, 
                    PageConst.welcomePage, 
                    (route) => false);
                  }, 
                  confirmTitle: "Log Out", 
                  content: "Are you sure want to Logout");
              }),
        ],
      ),
    );
  }

  _settingItemWidget(
      {String? title,
      String? description,
      IconData? icon,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Icon(
              icon,
              color: Colors.grey,
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title",
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                "$description",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ))
        ],
      ),
    );
  }
}
