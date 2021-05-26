import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageUpload {
  bool isUploaded;
  bool uploading; 
  PickedFile imageFile;
  String imageUrl;

  ImageUpload({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
