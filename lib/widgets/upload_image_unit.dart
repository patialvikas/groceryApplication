import 'dart:io';

import 'package:GroceriesApplication/utility/image/image_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageUnit extends StatefulWidget {
  final Function onImageSelect;
  final String imageFile;
  final PickedFile pickedFile;
  final int index;
  final Function onDelete;
  UploadImageUnit({
    this.onImageSelect,
    this.imageFile,
    this.pickedFile,
    this.index,
    this.onDelete,
  });
  @override
  _UploadImageUnitState createState() => _UploadImageUnitState();
}

class _UploadImageUnitState extends State<UploadImageUnit> {
  @override
  Widget build(BuildContext context) {
    return (widget.imageFile != null || widget.pickedFile != null)
        ? _getFilledCard(context)
        : _getEmptyCard(context);
  }

  Widget _getFilledCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          widget.pickedFile != null
              ? Image.file(
                  File(widget.pickedFile.path),
                  width: 300,
                  height: 300,
                )
              : widget.imageFile != null
                  ? Image.network(
                      widget.imageFile,
                      width: 300,
                      height: 300,
                    )
                  : null,
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
                  print('JJJJ');
                  widget.onDelete(widget.index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _onAddImageClick() async {
    await ImageUtility.showImageDialog(context, (PickedFile file) {
      widget.onImageSelect(file, widget.index);
    });
  }

  Widget _getEmptyCard(BuildContext context) {
    return Card(
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _onAddImageClick();
        },
      ),
    );
  }
}
