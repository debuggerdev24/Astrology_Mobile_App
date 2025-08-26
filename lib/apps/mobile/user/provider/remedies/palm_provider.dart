import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PalmProvider extends ChangeNotifier {
  File? leftHandImageFile, rightHandImageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({bool? isLeft}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isLeft ?? false) {
        leftHandImageFile = File(pickedFile.path);
      } else {
        rightHandImageFile = File(pickedFile.path);
      }
      notifyListeners();
    }
  }
}
