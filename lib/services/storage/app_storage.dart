import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppStorage {
  AppStorage({@required this.uid}) : assert(uid != null);
  final String uid;

  // Store Images
  Future<String> uploadStoreImages({
    @required File file,
    String fileName,
  }) async =>
      await uploadStore(
        file: file,
        path: 'storeImages/$uid',
        contentType: 'image/png',
        fileName: fileName,
      );
  Future<String> uploadStore({
    @required File file,
    @required String path,
    @required String contentType,
    @required String fileName,
  }) async {
    print('uploading to: $path');
    StorageReference storageReference;
    StorageUploadTask uploadTask;
    storageReference = FirebaseStorage.instance
        .ref()
        .child(path + '/' + fileName ?? 'storeImage.png');
    uploadTask = storageReference.putFile(
        file, StorageMetadata(contentType: contentType));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');

    return downloadUrl;
  }

  // Product Images
  Future<String> uploadProductImages(
          {@required File file, @required name}) async =>
      await uploadProduct(
        file: file,
        path: 'productImages/$uid/$name',
        contentType: 'image/png',
      );
  Future<String> uploadProduct({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    StorageReference storageReference;
    StorageUploadTask uploadTask;
    storageReference =
        FirebaseStorage.instance.ref().child(path);
    uploadTask = storageReference.putFile(
        file, StorageMetadata(contentType: contentType));
    final snapshot = await uploadTask.onComplete;
    if (snapshot.error != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot.error;
    }
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');

    return downloadUrl;
  }

 
}
