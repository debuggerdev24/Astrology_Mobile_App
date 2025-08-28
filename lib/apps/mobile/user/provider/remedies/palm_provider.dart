import 'dart:io';

import 'package:astrology_app/apps/mobile/user/model/remedies/palm_reading_model.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/Remedies/remedy_api_service.dart';

class PalmProvider extends ChangeNotifier {
  File? leftHandImageFile, rightHandImageFile;
  PalmReadingModel? palmReading;
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

  bool isUploading = false;
  Future<void> uploadForReading({required VoidCallback onSuccess}) async {
    isUploading = true;
    notifyListeners();
    FormData data = FormData.fromMap({
      "left_palm": await MultipartFile.fromFile(leftHandImageFile!.path),
      "right_palm": await MultipartFile.fromFile(rightHandImageFile!.path),
    });
    final result = await RemedyApiService.instance.uploadPalmFroReading(
      data: data,
    );
    result.fold(
      (l) {
        Logger.printError("--------------> ${l.errorMessage}");
      },
      (r) {
        palmReading = PalmReadingModel.fromJson(r["data"]);
        notifyListeners();
        onSuccess.call();
      },
    );
    isUploading = false;
    notifyListeners();
  }

  int selectedIndex = 0;
  void toggleHand({required int index}) {
    this.selectedIndex = index;
    notifyListeners();
  }
}
