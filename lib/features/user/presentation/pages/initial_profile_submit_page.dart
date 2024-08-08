import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/home/home_page.dart';
import 'package:flutter_application_10/features/user/domain/entities/user_entity.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/credential/cubit/credential_cubit.dart';
import 'package:flutter_application_10/storage/storage_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/global/widget/profile_widget.dart';
import '../../../app/theme/style.dart';

class InitialProfileSubmitPage extends StatefulWidget {
  final String phoneNumber;
  const InitialProfileSubmitPage({super.key, required this.phoneNumber});

  @override
  State<InitialProfileSubmitPage> createState() =>
      _InitialProfileSubmitPageState();
}

class _InitialProfileSubmitPageState extends State<InitialProfileSubmitPage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  bool _isProfileUpdating = false;
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No Image has been select");
        }
      });
    } catch (e) {
      print("Some error occurr $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Center(
              child: Text(
                "Profile Infor",
                style: TextStyle(
                    color: tabColor, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Please provide your name and an optioanl profile Photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: selectImage,
              child: SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profileWidget(image: _image),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: tabColor, width: 1.5))),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    hintText: "Username", border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: submitProfileInfor,
              child: Container(
                alignment: Alignment.center,
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void submitProfileInfor(){
    if(_image!=null){
      StorageProviderRemoteDataSource.uploadProfileImage(file: _image!,
      onComplete: (onProfileUpdateComplete){
        setState(() {
          _isProfileUpdating= onProfileUpdateComplete;
        });
      }).then((profileImageUrl){
        _profileInfor(profileUrl:profileImageUrl);
      });
    }else{
      _profileInfor(profileUrl:"");
    }
  }
  void _profileInfor({String? profileUrl}){
    if(_usernameController.text.isNotEmpty){
      BlocProvider.of<CredentialCubit>(context).submitProfileInfor(
        user: UserEntity(
          email: "",
          username: _usernameController.text,
          phoneNumber: widget.phoneNumber,
          status: "Hey there! I'm using WhatsApp",
          isOnline: false,
          profileUrl: profileUrl
        )
        );
    }
  }
}
