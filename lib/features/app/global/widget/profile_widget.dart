import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';

Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(
        'assets/profile_default.png',
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return CircularProgressIndicator(
            color: tabColor,
          );
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/profile_default.png',
            fit: BoxFit.cover,
          );
        },
      );
    }
  }else{
    return Image.file(image,fit: BoxFit.cover,);
  }
}
