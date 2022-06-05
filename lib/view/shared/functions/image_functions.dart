import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/toast_helper.dart';

class ImageHelper {
  Future<XFile?> takePhoto(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      return pickedFile;
    } else {
      showToast("cannot open gallery");
    }
    return null;
  }

  Future<String> uploadFile(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("Logos").child("file" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot task = await uploadTask.catchError((err) {
      showToast("Error while uploading the photo..");
    });

    String link = await task.ref.getDownloadURL();
    return link;
  }
}
