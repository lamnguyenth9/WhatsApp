

import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/app/home/contact_page.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';

import '../features/app/settings/settings_page.dart';
import '../features/call/presentation/pages/call_contact_page.dart';
import '../features/chat/presentation/pages/single_chat_page.dart';
import '../features/status/presentaion/pages/my_status_page.dart';
import '../features/user/presentation/pages/edit_profile_page.dart';

class OnGenerateRoute{
  static Route<dynamic>? route(RouteSettings settings){
    final args =settings.arguments;
    final name = settings.name;
    switch(name){ 
      case PageConst.contactUsersPage:
      {  
        if(args is String){
          return materialPageBuilder( ContactPage(uid: args));
        }else{
          return materialPageBuilder(const ErrorPage());
        }
        
      }
      case PageConst.settingsPage:{
        if(args is String){
          return materialPageBuilder(SettingsPage(uid: args,));
        }else{
          return materialPageBuilder(const ErrorPage());
        }
      }
      case PageConst.editProfilePage:{
        if(args is UserEntity){
          return materialPageBuilder(EditProfilePage(currentUser: args,));
        }else{
          return materialPageBuilder(const ErrorPage());
        }
      }
      case PageConst.callContactsPage:{
        return materialPageBuilder(const CallContactPage());
      }
      case PageConst.myStatusPage:{
        return materialPageBuilder(const MyStatusPage());
      }
      case PageConst.singleChatPage:{
        if(args is MessageEntity){
          return materialPageBuilder(SingleChatPage(message: args,));
        }else{
          return materialPageBuilder(const ErrorPage());
        }
      }
    }
    
  }
  
}
dynamic materialPageBuilder(Widget child){
    return MaterialPageRoute(builder: (_)=>child);
  }

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error Page"),
      ),
      body: const Center(
        child: Text("Error Page"),
      ),
    );
  }
}