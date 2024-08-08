import 'dart:async';
import 'dart:io';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/const/message_type_const.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_application_10/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/message/cubit/message_cubit.dart';
import 'package:flutter_application_10/features/chat/presentation/widget/chat_ultis.dart';
import 'package:flutter_application_10/storage/storage_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:giphy_picker/giphy_picker.dart';
import '../../../app/const/app_const.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity message;
  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool _isDisplaySendButton = false;
  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();

    BlocProvider.of<MessageCubit>(context).getMessage(
        message: MessageEntity(
            senderUid: widget.message.senderUid,
            recipientUid: widget.message.recipientUid));
    super.initState();
  }

  Future<void> _scrollToBottom() async {
    if (scrollController.hasClients) {
      await Future.delayed(Duration(milliseconds: 100));
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  File? _image;
  Future selectImage() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("no image has been selected");
      }
    } catch (e) {
      toast("Some error occurr $e");
    }
  }

  File? _video;
  Future selectVideo() async {
    setState(() => _image = null);
    try {
      final pickedFile =
          await ImagePicker.platform.pickVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _video = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  bool isShowAttachWindow = false;
  FlutterSoundRecorder? _soundRecorder;
  bool _isRecording = false;
  bool _isRecordInit = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("${widget.message.recipientName}"),
            const Text(
              "Online",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            )
          ],
        ),
        actions: const [
          Icon(
            Icons.videocam_rounded,
            size: 25,
          ),
          SizedBox(
            width: 25,
          ),
          Icon(
            Icons.call,
            size: 22,
          ),
          SizedBox(
            width: 25,
          ),
          Icon(
            Icons.more_vert,
            size: 22,
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: BlocBuilder<MessageCubit, MessageState>(builder: (context, state) {
        if (state is MessageLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          final messages = state.messages;
          return GestureDetector(
            onTap: () {
              isShowAttachWindow = false;
            },
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/whatsapp_bg_image.png",
                      fit: BoxFit.cover,
                    )),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          if (message.senderUid == widget.message.senderUid) {
                            return _messageLayout(
                                message: message.message,
                                aligment: Alignment.centerRight,
                                createAt: message.createdAt,
                                isSeen: false,
                                isShowTick: true,
                                messageBgColor: messageColor,
                                onLongPress: () {},
                                onSwipe: (value) {});
                          } else {
                            return _messageLayout(
                                message: message.message,
                                aligment: Alignment.centerLeft,
                                createAt: message.createdAt,
                                isSeen: true,
                                isShowTick: false,
                                messageBgColor: senderMessageColor,
                                onLongPress: () {},
                                onSwipe: (value) {});
                          }
                        },
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(children: [
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: appBarColor),
                            height: 50,
                            child: TextField(
                              onTap: () {
                                isShowAttachWindow = false;
                              },
                              controller: _textMessageController,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState(() {
                                    _isDisplaySendButton = true;
                                  });
                                } else {
                                  setState(() {
                                    _isDisplaySendButton = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  prefixIcon: const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Wrap(
                                      children: [
                                        Transform.rotate(
                                            angle: -0.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isShowAttachWindow =
                                                      !isShowAttachWindow;
                                                });
                                              },
                                              child: const Icon(
                                                Icons.attach_file,
                                                color: Colors.grey,
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        const Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              _sendTextMessage();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: tabColor),
                              child: Center(
                                child: Icon(
                                  _isDisplaySendButton
                                      ? Icons.send_outlined
                                      : _isRecording
                                          ? Icons.close
                                          : Icons.mic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ])),
                  ],
                ),
                isShowAttachWindow == true
                    ? Positioned(
                        bottom: 65,
                        top: 260,
                        left: 15,
                        right: 15,
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.2,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                          decoration: BoxDecoration(
                              color: bottomAttackContainerColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                      icon: Icons.document_scanner,
                                      color: Colors.deepPurpleAccent,
                                      title: "Document"),
                                  _attachWindowItem(
                                      icon: Icons.camera_alt,
                                      color: Colors.pinkAccent,
                                      title: "Camera"),
                                  _attachWindowItem(
                                      icon: Icons.image,
                                      color: Colors.purpleAccent,
                                      title: "Gallery")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                      icon: Icons.headphones,
                                      color: Colors.deepOrange,
                                      title: "Audio"),
                                  _attachWindowItem(
                                      icon: Icons.location_on,
                                      color: Colors.green,
                                      title: "Location"),
                                  _attachWindowItem(
                                      icon: Icons.account_circle,
                                      color: Colors.deepPurpleAccent,
                                      title: "Contact")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _attachWindowItem(
                                      icon: Icons.bar_chart,
                                      color: tabColor,
                                      title: "Poll"),
                                  _attachWindowItem(
                                      icon: Icons.gif_box_outlined,
                                      color: Colors.indigoAccent,
                                      title: "Gift"),
                                  _attachWindowItem(
                                      icon: Icons.videocam_rounded,
                                      color: Colors.lightGreen,
                                      title: "Video")
                                ],
                              )
                            ],
                          ),
                        ))
                    : Container()
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  _messageLayout(
      {Color? messageBgColor,
      Alignment? aligment,
      Timestamp? createAt,
      Function(DragUpdateDetails)? onSwipe,
      String? message,
      bool? isShowTick,
      bool? isSeen,
      VoidCallback? onLongPress}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SwipeTo(
        onRightSwipe: onSwipe,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            alignment: aligment,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(
                            left: 5, right: 85, top: 5, bottom: 5),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.80),
                        decoration: BoxDecoration(
                            color: messageBgColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          "$message",
                          style: const TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(createAt!.toDate()),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white)),
                      const SizedBox(
                        width: 5,
                      ),
                      isShowTick == true
                          ? Icon(
                              isSeen == true ? Icons.done_all : Icons.done,
                              size: 16,
                              color:
                                  isSeen == true ? Colors.blue : Colors.white,
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attachWindowItem(
      {IconData? icon, Color? color, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: color),
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "$title",
            style: const TextStyle(color: greyColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  _sendTextMessage() async {
    if (_isDisplaySendButton) {
      _sendMessage(
          message: _textMessageController.text,
          type: MessageTypeConst.textMessage);
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final audioPath = '${temporaryDir.path}/flutter_sound.aac';
      if (!_isRecordInit) {
        return;
      }
      if (_isRecording == true) {
        await _soundRecorder!.stopRecorder();
        StorageProviderRemoteDataSource.uploadMessageFile(
                file: File(audioPath),
                onComplete: (value) {},
                otherUid: widget.message.recipientUid,
                uid: widget.message.senderUid,
                type: MessageTypeConst.audioMessage)
            .then((audioUrl) {
          _sendMessage(message: audioUrl, type: MessageTypeConst.audioMessage);
        });
      } else {
        await _soundRecorder?.startRecorder(toFile: audioPath);
      }
      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  void _sendImageMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
            file: _image!,
            onComplete: (onVale) {},
            uid: widget.message.senderUid,
            otherUid: widget.message.recipientUid,
            type: MessageTypeConst.photoMessage)
        .then((photoImageUrl) {
      _sendMessage(message: photoImageUrl, type: MessageTypeConst.photoMessage);
    });
  }

  void _sendVideoMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
            file: _video!,
            onComplete: (onVale) {},
            uid: widget.message.senderUid,
            otherUid: widget.message.recipientUid,
            type: MessageTypeConst.videoMessage)
        .then((videoUrl) {
      _sendMessage(message: videoUrl, type: MessageTypeConst.videoMessage);
    });
  }

  Future _sendGifMessage() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      _sendMessage(message: fixedUrl, type: MessageTypeConst.giftMessage);
    }
  }

  void _sendMessage(
      {required String message,
      required String type,
      String? repliedMessage,
      String? repliedTo,
      String? repliedMessageType}) {
    _scrollToBottom();
    ChatUltis.sendMessage(context,
            messageEntity: widget.message,
            repliedMessage: repliedMessage,
            repliedTo: repliedTo,
            repliedMessageType: repliedMessageType,
            type: type,
            message: message)
        .then((value) {
      setState(() {
        _textMessageController.clear();
      });
      _scrollToBottom();
    });
  }
}
