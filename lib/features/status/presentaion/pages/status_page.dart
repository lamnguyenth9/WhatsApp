
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/page_const.dart';
import 'package:flutter_application_10/features/app/global/date/date_fornats.dart';
import 'package:flutter_application_10/features/app/global/widget/profile_widget.dart';
import 'package:flutter_application_10/features/app/global/widget/show_image_and_video_widget.dart';
import 'package:flutter_application_10/features/app/home/home_page.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/status/domain/entities/status_entity.dart';
import 'package:flutter_application_10/features/status/domain/use_cases/get_my_status_future_usecase.dart';
import 'package:flutter_application_10/features/status/presentaion/cubit/get_my_status/cubit/get_my_status_cubit.dart';
import 'package:flutter_application_10/features/status/presentaion/cubit/get_status/cubit/status_cubit.dart';
import 'package:flutter_application_10/features/status/presentaion/widgets/status_dotted_border_widget.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:flutter_application_10/storage/storage_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:intl/intl.dart';
import 'package:flutter_story_view/models/story_item.dart';
import '../../domain/entities/status_image_entity.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_application_10/main_injection_container.dart' as di;

class StatusPage extends StatefulWidget {
  final String uid;
  const StatusPage({super.key, required this.uid});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<StatusImageEntity> _stories = [];
  List<StoryItem> myStories = [];
  List<File>? _selectedMedia;
  List<String>? _mediaType;
  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaType = null;
    });
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.media, allowMultiple: true);
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();
        _mediaType = List<String>.filled(_selectedMedia!.length, '');
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaType![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == 'aiv') {
            _mediaType![i] = 'video';
          }
        }
        setState(() {});
        print("mediaType: $_mediaType");
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("error while picking file: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StatusCubit>(context).getStatus(status: StatusEntity());
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    BlocProvider.of<GetMyStatusCubit>(context).getMyStatus(uid: widget.uid);
    di.sl<GetMyStatusFutureUsecase>().call(widget.uid).then((myStatus) {
      if (myStatus.isNotEmpty && myStatus.first.stories != null) {
        _fillMyStoriesList(myStatus.first);
      }
    });
  }

  Future _fillMyStoriesList(StatusEntity status) async {
    if (status.stories != null) {
      _stories = status.stories!;
      for (StatusImageEntity story in status.stories!) {
        myStories.add(StoryItem(
            url: story.url!,
            type: StoryItemTypeExtension.fromString(story.type!),
            viewers: story.viewers!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if (state is GetSingleUserLoaded) {
          final currentUser = state.singleUser;
          return BlocBuilder<StatusCubit, StatusState>(
            builder: (context, state) {
              if (state is StatusLoaded) {
                final statuses = state.statuses;
                if (_stories.isEmpty) {
                  return _bodyWidget(statuses, currentUser);
                } else {
                  return BlocBuilder<GetMyStatusCubit, GetMyStatusState>(
                    builder: (context, state) {
                      if (state is GetMyStatusLoaded) {
                        return _bodyWidget(statuses, currentUser,
                            myStatus: state.myStatus);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                }
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
      },
    );
  }

  _bodyWidget(List<StatusEntity> statuses, UserEntity currentUser,
      {StatusEntity? myStatus}) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  myStatus != null
                      ? GestureDetector(
                          onTap: () {
                            _etherShowOrUploadSheet(myStatus, currentUser);
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.all(12.5),
                            child: CustomPaint(
                              painter: StatusDottedBordersWidget(
                                  numberOfStories: myStatus.stories!.length,
                                  isMe: true,
                                  spaceLength: 4,
                                  images: myStatus.stories!,
                                  uid: widget.uid),
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                width: 55,
                                height: 55,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: profileWidget(
                                      imageUrl: myStatus.imageUrl),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child:
                                profileWidget(imageUrl: currentUser.profileUrl),
                          ),
                        ),
                  myStatus!=null
                  ?Container()
                  : Positioned(
                      right: 10,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: (){
                          _etherShowOrUploadSheet(myStatus, currentUser);
                        },
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
                        ),
                      ))
                ],
              ),
               Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Status",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  GestureDetector(
                    onTap:(){
                      _etherShowOrUploadSheet(myStatus, currentUser);
                    } ,
                    child: const Text(
                      "Tap to add your status update",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              )),
              GestureDetector(
                  onTap: () {
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
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            itemCount: statuses.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              final status=statuses[index];
              return ListTile(
                onTap: (){
                  _etherShowOrUploadSheet(status, currentUser);
                },
                leading: SizedBox(
                  height: 55,
                  width: 55,
                  child: CustomPaint(
                    painter: StatusDottedBordersWidget(
                      spaceLength: 4,
                      numberOfStories: status.stories!.length, 
                      isMe: false,
                      images: status.stories,
                      uid: widget.uid),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        width: 55,
                        height: 55,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(imageUrl: status.imageUrl),
                        ),
                      ),
                  ),
                ),
                title: Text(
                  "${status.username}",
                  style: const TextStyle(fontSize: 16 ),
                ),
                subtitle: Text(formatDateTime( status.createdAt!.toDate())),

              );
            },
          )
        ],
      ),
    ));
  }
  Future _showStatusImageViewBottomModelSheet({StatusEntity? status,required List<StoryItem> stories})async{
       showModalBottomSheet(
        isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
        context: context, 
        builder: (context) {
          return FlutterStoryView(
            onComplete: (){Navigator.pop(context);}, 
            storyItems:stories,
            enableOnHoldHide: false,
            caption: "This is very beautifull photo",
            onPageChanged: (index){
              BlocProvider.of<StatusCubit>(context)
              .seenStatusUpdate(statusId: status.statusId!, imageIndex: index, userId: widget.uid);
            }, 
            createdAt: status!.createdAt!.toDate(),
            );
        },);
  }
  void _etherShowOrUploadSheet(StatusEntity? myStatus, UserEntity currentUser) {
    if(myStatus!=null){
        _showStatusImageViewBottomModelSheet(status: myStatus, stories: myStories);
    }else{
      selectMedia().then(
        (value){
          if(_selectedMedia!=null && _selectedMedia!.isNotEmpty){
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: false,
               builder: (context) {
                 return ShowMultiImageAndVideoPickedWidget(
                  selectedFiles: _selectedMedia!, 
                  onTap: (){
                    _uploadImageStatus(currentUser);
                    Navigator.pop(context);
                  });
               },);
          }
        }
      );
    }
  }
  
   _uploadImageStatus(UserEntity currentUser) {
    StorageProviderRemoteDataSource.uploadStatuses(
      files: _selectedMedia!,
      onComplete: (onCompleteStatusUpload){})
      .then((statusImageUrls){
        for(int i=0;i<statusImageUrls.length;i++){
          _stories.add(StatusImageEntity(
            url: statusImageUrls[i],
            type: _mediaType![i],
            viewers: const[]
          ));
        }
        di.sl<GetMyStatusFutureUsecase>().call(widget.uid).then((myStatus){
          if(myStatus.isNotEmpty){
            BlocProvider.of<StatusCubit>(context)
            .updateOnlyImageStatus(status: StatusEntity(statusId: myStatus.first.statusId,stories: _stories))
            .then((value){
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (_)=>HomePage(uid: widget.uid,index: 1,)));
            });
          }else{
            BlocProvider.of<StatusCubit>(context)
            .createStatus(status: StatusEntity(
              caption: "",
              createdAt: Timestamp.now(),
              stories: _stories,
              username: currentUser.username,
              uid: currentUser.uid,
              profileUrl: currentUser.profileUrl,
              imageUrl: statusImageUrls[0],
              phoneNumber: currentUser.phoneNumber
            )).then((value){
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (_)=>HomePage(uid: widget.uid,index: 1,)));
            });
          }
        });
      });
   }
}
