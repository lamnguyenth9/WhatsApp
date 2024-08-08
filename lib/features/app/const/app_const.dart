import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giphy_picker/giphy_picker.dart';

void toast(String message){
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: tabColor,
    textColor: Colors.white,
    fontSize: 16
    );
}

Future<GiphyGif?> pickGIF(BuildContext context) async{
  GiphyGif? gif;
  try{
    gif=await GiphyPicker.pickGif(
      context: context,
      apiKey: 'kLu4PIKAwS2ys47Ji7oWUIr2iZbEoj1k'
    );
  }catch(e){
    print(e.toString());
  }
  return gif;
}