import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtility {
  static final picker = ImagePicker();

  static Future<void> showImageDialog(BuildContext context, Function setImage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: (() async {
                    final img = await _getImageFromGallery(context);
                    print('GGG');
                    setImage(img);
                  }),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: (() async {
                    final img = await getImageFromCamera(context);
                    setImage(img);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<PickedFile> getImageFromCamera(BuildContext context) async {
    var image = await picker.getImage(source: ImageSource.camera);
    return image;
  }

  static Future<PickedFile> _getImageFromGallery(BuildContext context) async {
    var image = await picker.getImage(source: ImageSource.gallery);
    return image;
  }
}
