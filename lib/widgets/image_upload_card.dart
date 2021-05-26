import 'dart:io';

import 'package:GroceriesApplication/models/image_upload.dart';
import 'package:GroceriesApplication/utility/image/image_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadCard extends StatefulWidget {
  final bool isFresh;
  ImageUploadCard({
    this.isFresh,
  });
  @override
  _ImageUploadCardState createState() => _ImageUploadCardState();
}

class _ImageUploadCardState extends State<ImageUploadCard> {
  List<Object> images = List<Object>();
  Future<File> _imageFile;
  List<PickedFile> _imageList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUpload) {
          ImageUpload uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  File(uploadModel.imageFile.path),
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  _setImage(final file, int index) {
    setState(() {
      _imageList.add(file);
    });
    getFileImage(index);
    Navigator.pop(context);
  }

  Future _onAddImageClick(int index) async {
    ImageUtility.showImageDialog(context, (final file) {
      _setImage(file, index);
    });
  }

  void getFileImage(int index) async {
    setState(() {
      ImageUpload imageUpload = new ImageUpload();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = _imageList[index];
      imageUpload.imageUrl = '';
      images.replaceRange(index, index + 1, [imageUpload]);
    });
  }
}
