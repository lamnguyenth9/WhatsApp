import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/app/home/contact_page.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/call/presentation/pages/call_history_page.dart';
import 'package:flutter_application_10/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_application_10/features/status/presentaion/pages/status_page.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/user/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final int? index;
  final String uid;
  const HomePage({super.key, required this.uid,  this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  TabController? _tabController;
  int _currentIndex=0;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _tabController=TabController(length: 3,vsync: this);
    _tabController!.addListener((){
      setState(() {
        _currentIndex=_tabController!.index;
      });
    });
    if(widget.index!=null){
      setState(() {
        _currentIndex=widget.index!;
        _tabController!.animateTo(1);
      });
    }
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
    super.dispose();
  }
  @override
  void didChangeApplifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    switch(state){
      
      case AppLifecycleState.detached:
        // TODO: Handle this case.
      case AppLifecycleState.resumed:
        BlocProvider.of<UserCubit>(context).updateUser(user: 
        UserEntity(
          uid: widget.uid,
          isOnline: true
        ));
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        BlocProvider.of<UserCubit>(context).updateUser(user: 
        UserEntity(
          uid: widget.uid,
          isOnline: false 
        ));
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WhatsApp",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
            Row(
            children: [
               const Icon(Icons.camera_alt_outlined,color: Colors.grey,size: 28),
              const SizedBox(width: 25,),
              const Icon(Icons.search,color: Colors.grey,size: 28),
              const SizedBox(width: 10,),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert,color: Colors.grey,size: 28,),
                color: appBarColor,
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                   PopupMenuItem<String>(
                          value: "Settings",
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, PageConst.settingsPage,arguments: widget.uid);
                              },
                              child: const Text('Settings')),
                        ),
                ],)
            ],
          ),
          
        ],
        bottom: TabBar(
          labelColor: tabColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: tabColor,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                "Chats", 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Tab(
              child: Text(
                "Status", 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Tab(
              child: Text(
                "Calls", 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ]),
      ),
      floatingActionButton: switchFloatingActionButton(_currentIndex),
      body: TabBarView(
        controller: _tabController,
        children:  [
          ChatPage(uid: widget.uid,),
           StatusPage(uid: widget.uid,),
          const CallHistoryPage()
        ]),
    );
  }
  switchFloatingActionButton(int index){
    switch(index){
      case 0:
      {
         return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (_)=>ContactPage()));
            Navigator.pushNamed(context, PageConst.contactUsersPage,arguments: widget.uid);
          },
          child: const Icon(
            Icons.message, color: Colors.white,
          ),
          );
      }
      case 1:
      {
         return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: (){
            
          },
          child: const Icon(
            Icons.camera, color: Colors.white,
          ),
          );
      }
      case 2:
      {
         return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: (){
            Navigator.pushNamed(context, PageConst.callContactsPage,); 
          },
          child: const Icon(
            Icons.add_call, color: Colors.white,
          ),
          );
      }
      default:
      return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: (){},
          child: const Icon(
            Icons.message, color: Colors.white,
          ),
          );
    }
  }
}