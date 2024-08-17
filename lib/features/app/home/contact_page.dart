import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_single_user/cubit/get_single_user_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat/domain/entities/message_entity.dart';
import '../../user/presentation/bloc/user/cubit/user_cubit.dart';
import '../global/widget/profile_widget.dart';

class ContactPage extends StatefulWidget {
  final String uid;
  const ContactPage({super.key, required this.uid});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getAllUsers();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
      ),
      body: BlocBuilder<GetSingleUserCubit,GetSingleUserState>(
        builder: (context, state) {
          if(state is GetSingleUserLoaded){
            final currentUser=state.singleUser;
            return BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            final contacts = state.users.where((user)=>user.uid!=widget.uid ).toList();
            if (contacts.isEmpty) {
              return const Center(
                child: Text("No Contacts Yet"),
              );
            }
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, PageConst.singleChatPage,
                  arguments: MessageEntity(
                    senderName: currentUser.username,
                    senderUid: currentUser.uid,
                    senderProfile: currentUser.profileUrl,
                    recipientName: contact.username,
                    recipientProfile: contact.profileUrl,
                    recipientUid: contact.uid,
                    uid:widget.uid
                  ));
                  },
                  child: ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: profileWidget(imageUrl: contact.profileUrl)),
                    ),
                    title: Text("${contact.username}"),
                    subtitle: Text("${contact.status}"),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },)
    );
  }
}

// FIXME:        Logic to fetch contact of the phone
// BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
//         builder: (context, state) {
//           if(state is GetDeviceNumberLoaded){
//             final contacts=state.contacts;
//             return ListView.builder(
//             itemCount: contacts.length,
//             itemBuilder: (context, index) {
//               final contact=contacts[index];
//               return ListTile(
//                 leading: SizedBox(
//                   height: 50,
//                   width: 50,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(25),
//                     child: Image.memory(
//                       contact.photo??Uint8List(0),
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset("assets/profile_default.pnf");
//                       },
//                     ),
//                   ),
//                 ),
//                 title:  Text("${contact.name!.first} ${contact.name!.last}"),
//                 subtitle: const Text("Hey there! I'm using WhatsApp"),
//               );
//             },
//           );
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),