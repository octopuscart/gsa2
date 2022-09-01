import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class UIElements {
  imageBlock({required String localpath, required String imagepath}) {
    if (localpath != "") {
      print("If conditions");
      return Image.file(
        File(localpath),
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: Container(
              child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.asset(
                "assets/placeholder.png",
                height: 200,
              ),
              CircularProgressIndicator(
                value: progress.progress,
              )
            ],
          )),
        ),
        imageUrl: imagepath.toString(),
      );
    }
  }
}
