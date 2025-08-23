import 'dart:io';

import 'package:astrology_app/apps/mobile/user/services/profile_api_service.dart';
import 'package:astrology_app/core/utils/field_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/custom_toast.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../model/settings/profile_model.dart';
import '../../services/locale_storage_service.dart';

class UserProfileProvider extends ChangeNotifier {
  // Text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController birthTimeController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  TextEditingController editNameController = TextEditingController();
  TextEditingController editCurrentLocationController = TextEditingController();
  TextEditingController editBirthPlaceController = TextEditingController();
  TextEditingController editBirthTimeController = TextEditingController();
  TextEditingController editBirthDateController = TextEditingController();

  String? leftHandImageUrl;
  String? rightHandImageUrl;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;

  DateTime get birthDate => _birthDate!;
  TimeOfDay get birthTime => _birthTime!;

  File? leftHandImageFile;
  File? rightHandImageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isAgreementChecked = false;
  bool get isAgreementChecked => _isAgreementChecked;

  String errorNameStr = "";
  String errorPlaceOfBirthStr = "";
  String errorCurrentLocationStr = "";
  String errorDOBStr = "";
  String errorTOBStr = "";

  void toggleAgreement() {
    _isAgreementChecked = !_isAgreementChecked;
    notifyListeners();
  }

  Future<void> pickImage({required bool isLeft}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isLeft) {
        leftHandImageFile = File(pickedFile.path);
      } else {
        rightHandImageFile = File(pickedFile.path);
      }
      notifyListeners();
    }
  }

  //todo ---------------> get profile
  bool isGetProfileLoading = false;
  Future<void> getProfile(BuildContext context) async {
    // if (_validateRegisterData()) return;
    isGetProfileLoading = true;
    notifyListeners();
    final result = await UserProfileService.instance.getProfile();

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        final profile = UserProfileModel.fromJson(data["data"]);
        //todo profile screen controller assigned here
        nameController.text = profile.fullName;
        currentLocationController.text = profile.currentLocation;
        birthPlaceController.text = profile.birthPlace;
        birthTimeController.text = profile.birthTime;
        birthDateController.text = profile.birthDate;
        leftHandImageUrl = profile.palmImageLeft;
        rightHandImageUrl = profile.palmImageRight;

        //todo edit profile screen controller assigned here

        isGetProfileLoading = false;
        notifyListeners();
      },
    );
  }

  assignEditorFields() {
    editNameController.text = nameController.text;
    editCurrentLocationController.text = currentLocationController.text;
    editBirthPlaceController.text = birthPlaceController.text;
    editBirthTimeController.text = birthTimeController.text;
    editBirthDateController.text = birthDateController.text;
    leftHandImageFile = null;
    rightHandImageFile = null;
  }

  //todo ---------------> edit profile
  bool isUpdateProfileLoading = false;
  Future<void> updateProfile({
    required BuildContext context,
    bool? isFromEditScreen,
  }) async {
    if (_validateEditFields()) return;
    isUpdateProfileLoading = true;
    notifyListeners();
    final result = (isFromEditScreen ?? false)
        ? await UserProfileService.instance.updateProfile(
            fullName: editNameController.text.trim(),
            birthDate: editBirthDateController.text.trim(),
            birthTime: editBirthTimeController.text.trim(),
            birthPlace: editBirthPlaceController.text.trim(),
            currentLocation: editCurrentLocationController.text.trim(),
            leftPalmImage: (leftHandImageFile == null)
                ? null
                : leftHandImageFile!.path,
            rightPalmImage: (rightHandImageFile == null)
                ? null
                : rightHandImageFile!.path,
          )
        : await UserProfileService.instance.updateProfile(
            fullName: nameController.text.trim(),
            birthDate: birthDateController.text.trim(),
            birthTime: birthTimeController.text.trim(),
            birthPlace: birthPlaceController.text.trim(),
            currentLocation: currentLocationController.text.trim(),
            leftPalmImage: leftHandImageFile!.path,
            rightPalmImage: rightHandImageFile!.path,
          );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(
          context: context,
          message: 'Profile Updated Successfully',
        );
        context.pushNamed(MobileAppRoutes.userDashBoardScreen.name);
        PrefHelper.setProfileCreated(true);
      },
    );
    isUpdateProfileLoading = false;

    notifyListeners();
  }

  // Format date manually without intl (matching your existing format)

  // Format time manually without intl (matching your existing format)
  // String get formattedBirthTime {
  //   if (_birthTime == null) return "";
  //
  //   final hour = _birthTime!.hourOfPeriod == 0 ? 12 : _birthTime!.hourOfPeriod;
  //   // final minute = _birthTime!.minute.toString().padLeft(2, '0');
  //   // final period = _birthTime!.period == DayPeriod.am ? "AM" : "PM";
  //   return hour.toString().padLeft(2, '0'); //:$minute $period
  // }

  Future<void> pickBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.whiteColor,
              // Purple for selected date
              onPrimary: AppColors.black,
              outline: AppColors.whiteColor,
              surface: AppColors.bgColor,
              // Dark background
              onSurface: AppColors.whiteColor,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _birthDate = picked;
      final day = _birthDate!.day.toString().padLeft(2, '0');
      final month = _birthDate!.month.toString().padLeft(2, '0');
      final year = _birthDate!.year.toString();
      birthDateController.text = "$year-$month-$day";

      notifyListeners();
    }
  }

  Future<void> pickBirthTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.whiteColor,
              // Purple for selected date
              onPrimary: AppColors.black,
              outline: AppColors.whiteColor,
              surface: AppColors.bgColor,
              // Dark background
              onSurface: AppColors.whiteColor,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _birthTime = picked;
      final hour = _birthTime!.hourOfPeriod == 0
          ? 12
          : _birthTime!.hourOfPeriod.toString().padLeft(2, '0');
      final minute = _birthTime!.minute.toString().padLeft(2, '0');

      birthTimeController.text = "$hour:$minute";
      notifyListeners();
    }
  }

  bool _validateEditFields() {
    errorNameStr = FieldValidators().fullName(editNameController.text.trim());
    if (errorNameStr.isNotEmpty) {
      return true;
    }
    return false;
  }
}
