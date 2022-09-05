import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class UIElements {
  menuButton({String? title, Function()? onPressed, IconData? icon}) {
    return Container(
        width: 120,
        // padding: EdgeInsets.all(7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                // size: 16,
              ),
            ),
          ],
        ));
  }

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
