import 'dart:io';

import 'package:astrology_app/apps/mobile/user/model/remedies/birth_chart_model.dart';
import 'package:astrology_app/apps/mobile/user/model/remedies/palm_reading_model.dart';
import 'package:astrology_app/core/utils/custom_toast.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/remedies/remedy_model.dart';
import '../../services/Remedies/remedy_api_service.dart';

class PalmProvider extends ChangeNotifier {
  File? leftHandImageFile, rightHandImageFile;
  PalmReadingModel? palmReading;
  BirthChartModel? birthChartDetails;
  RemedyModel? remedies;
  RemedyDetailsModel? remedyDetails;
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
  Future<void> uploadForReading({
    required VoidCallback onSuccess,
    required BuildContext context,
  }) async {
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
        AppToast.error(context: context, message: l.errorMessage);
      },
      (r) {
        palmReading = PalmReadingModel.fromJson(r["data"]);
        onSuccess.call();
        leftHandImageFile = null;
        rightHandImageFile = null;
        notifyListeners();
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

  bool isGetBirthChartLoading = false;
  Future<void> getBirthChartDetails() async {
    isGetBirthChartLoading = true;
    notifyListeners();
    final result = await RemedyApiService.instance.getBirthChartDetails();
    result.fold(
      (l) {
        Logger.printError("--------------> ${l.errorMessage}");
      },
      (r) {
        birthChartDetails = BirthChartModel.fromJson(r["data"]);
      },
    );
    isGetBirthChartLoading = false;
    notifyListeners();
  }

  bool isGetRemediesLoading = false;
  Future<void> getRemedies() async {
    isGetRemediesLoading = true;
    notifyListeners();
    final result = await RemedyApiService.instance.getRemedies();
    result.fold(
      (l) {
        Logger.printError("--------------> ${l.errorMessage}");
      },
      (r) {
        remedies = RemedyModel.fromJson(r["data"]);
      },
    );
    isGetRemediesLoading = false;
    notifyListeners();
  }

  bool isGetRemediesDetailsLoading = false;
  Future<void> getRemedyDetails({required String remedyId}) async {
    isGetRemediesDetailsLoading = true;
    notifyListeners();
    final result = await RemedyApiService.instance.getRemedyDetails(
      remedyId: remedyId,
    );
    result.fold(
      (l) {
        Logger.printError("--------------> ${l.errorMessage}");
      },
      (r) {
        remedyDetails = RemedyDetailsModel.fromJson(r["data"]);
      },
    );
    isGetRemediesDetailsLoading = false;
    notifyListeners();
  }
}
