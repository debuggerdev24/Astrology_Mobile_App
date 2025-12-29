import 'dart:io';

import 'package:astrology_app/apps/mobile/user/services/settings/profile_api_service.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/field_validator.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/custom_toast.dart';
import '../../../../../main.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../model/settings/profile_model.dart';
import '../../services/settings/locale_storage_service.dart';

class UserProfileProvider extends ChangeNotifier {
  // Text controllers
  TextEditingController nameController = TextEditingController(
    text: LocaleStoaregService.loggedInUserName,
  );
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController birthTimeController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  TextEditingController editNameController = TextEditingController();
  TextEditingController editCurrentLocationController = TextEditingController();
  TextEditingController editBirthPlaceController = TextEditingController();
  TextEditingController editBirthTimeController = TextEditingController();
  TextEditingController editBirthDateController = TextEditingController();

  String? leftHandImageUrl, rightHandImageUrl;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;

  DateTime get birthDate => _birthDate!;
  TimeOfDay get birthTime => _birthTime!;
  String? _originalActivePalm;

  File? leftHandImageFile, rightHandImageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isAgreementChecked = false;
  bool get isAgreementChecked => _isAgreementChecked;

  String errorNameStr = "",
      errorPlaceOfBirthStr = "",
      errorCurrentLocationStr = "",
      errorDOBStr = "",
      errorTOBStr = "";

  String _activePalm = 'right';

  String get activePalm => _activePalm;

  void setActivePalm(String palm) {
    _activePalm = palm;
    notifyListeners();
  }

  void toggleAgreement() {
    _isAgreementChecked = !_isAgreementChecked;
    LocaleStoaregService.setProfileCreated(_isAgreementChecked);
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
  bool isGetProfileLoading = true;
  Future<void> getProfile(BuildContext context) async {
    // if (_validateRegisterData()) return;
    isGetProfileLoading = true;
    notifyListeners();
    final result = await UserProfileService.instance.getProfile();

    result.fold(
      (failure) {
        Logger.printInfo(failure.errorMessage);
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
        isGetProfileLoading = false;
        _activePalm = profile.activePalm;
        _originalActivePalm = profile.activePalm;
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
    errorNameStr = "";
    errorPlaceOfBirthStr = "";
    errorCurrentLocationStr = "";
    errorDOBStr = "";
    errorTOBStr = "";
  }

  //todo ---------------> update profile
  bool isUpdateProfileLoading = false;
  Future<void> updateProfile({
    required BuildContext context,
    bool? isFromEdit,
  }) async {
    if (isFromEdit ?? false) {
      if (_validateEditFields(context)) return;
    } else {
      if (_validateFields(context)) return;
    }
    if (LocaleStoaregService.profileCreated) {
      if (!isNetworkConnected.value) {
        AppToast.info(
          context: context,
          message: "Unable to connect. Please check your internet connection.",
        );
        return;
      }
      if (!_isProfileChanged()) {
        AppToast.info(
          context: context,
          message: "No updates found. Please make changes before saving.",
          durationSecond: 2,
        );
        return;
      }
      isUpdateProfileLoading = true;
      notifyListeners();
      final result = (isFromEdit ?? false)
          ? await UserProfileService.instance.updateProfile(
              fullName: editNameController.text.trim(),
              birthDate: editBirthDateController.text.trim(),
              birthTime: editBirthTimeController.text.trim(),
              birthPlace: editBirthPlaceController.text.trim(),
              currentLocation: editCurrentLocationController.text.trim(),
              activePalm: activePalm,
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
              activePalm: "left",
            );

      result.fold(
        (failure) {
          Logger.printInfo(failure.errorMessage);
          AppToast.error(context: context, message: failure.errorMessage);
        },

        (data) async {
          await LocaleStoaregService.setProfileCreated(true);
          if (isFromEdit ?? false) {
            AppToast.success(
              context: context,
              message: context.translator.profileUpdatedSuccessfully,
            );
          }

          // callInitAPIs(context: context);

          context.pushNamed(MobileAppRoutes.userDashBoardScreen.name);
        },
      );
      isUpdateProfileLoading = false;
      notifyListeners();
      return;
    }
    AppToast.warning(
      context: context,
      message: context
          .translator
          .checkBoxWarningMessage, //"Please check the box to agree to the terms and continue.",
    );
  }

  clearControllers() {
    // nameController.clear();
    birthDateController.clear();
    birthTimeController.clear();
    birthPlaceController.clear();
    currentLocationController.clear();
    leftHandImageFile = rightHandImageFile = null;
  }

  //todo ------------------- Date Picker
  Future<void> pickBirthDate({
    required BuildContext context,
    bool? isFromEdit,
  }) async {
    final picked = await showDatePicker(
      barrierColor: AppColors.black.withValues(alpha: 0.6),
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 1)),

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

      if (isFromEdit ?? false) {
        editBirthDateController.text = "$day-$month-$year";
      } else {
        birthDateController.text = "$day-$month-$year";
      }

      notifyListeners();
    }
  }

  Future<void> pickBirthTime({
    required BuildContext context,
    bool? isFromEdit,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        Duration initialTimer = Duration(
          hours: _birthTime?.hour ?? TimeOfDay.now().hour,
          minutes: _birthTime?.minute ?? TimeOfDay.now().minute,
          seconds: 0,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Done button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  "Done",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ),
            CupertinoTheme(
              data: CupertinoThemeData(
                primaryColor: AppColors.redColor,
                brightness: Brightness.dark,
              ),

              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms, // hours:minutes:seconds
                initialTimerDuration: initialTimer,

                onTimerDurationChanged: (Duration newTime) {
                  final hours = newTime.inHours;
                  final minutes = newTime.inMinutes % 60;
                  final seconds = newTime.inSeconds % 60;

                  // Save in your variable
                  _birthTime = TimeOfDay(hour: hours, minute: minutes);

                  // Update text controller with HH:MM:SS
                  final time =
                      "${hours.toString().padLeft(2, '0')}:"
                      "${minutes.toString().padLeft(2, '0')}:"
                      "${seconds.toString().padLeft(2, '0')}";
                  if (isFromEdit ?? false) {
                    editBirthTimeController.text = time;
                  } else {
                    birthTimeController.text = time;
                  }
                },
              ),
            ),
            20.h.verticalSpace,
          ],
        );
      },
    );
  }

  bool _isProfileChanged() {
    final isTextChanged =
        nameController.text.trim() != editNameController.text.trim() ||
        currentLocationController.text.trim() !=
            editCurrentLocationController.text.trim() ||
        birthPlaceController.text.trim() !=
            editBirthPlaceController.text.trim() ||
        birthTimeController.text.trim() !=
            editBirthTimeController.text.trim() ||
        birthDateController.text.trim() != editBirthDateController.text.trim();

    final isImageChanged =
        leftHandImageFile != null || rightHandImageFile != null;
    final isPalmChanged = _activePalm != _originalActivePalm;

    return isTextChanged || isImageChanged || isPalmChanged;
  }

  //todo ------------> validation functions
  bool _validateFields(BuildContext context) {
    errorNameStr = FieldValidators().fullName(
      context,
      nameController.text.trim(),
    );
    errorDOBStr = FieldValidators().required(
      context,
      birthDateController.text.trim(),
      context.translator.dateOfBirth,
    );
    errorTOBStr = FieldValidators().required(
      context,
      birthTimeController.text.trim(),
      context.translator.timeOfBirth,
    );
    errorPlaceOfBirthStr = FieldValidators().required(
      context,
      birthPlaceController.text.trim(),
      context.translator.placeOfBirth,
    );
    errorCurrentLocationStr = FieldValidators().required(
      context,
      currentLocationController.text.trim(),
      context.translator.currentLocation,
    );
    // if()

    if ((leftHandImageFile == null || rightHandImageFile == null)) {
      AppToast.error(context: context, message: "Please enter palm image");
    }
    notifyListeners();

    if (errorNameStr.isNotEmpty ||
        errorCurrentLocationStr.isNotEmpty ||
        errorDOBStr.isNotEmpty ||
        errorTOBStr.isNotEmpty ||
        errorPlaceOfBirthStr.isNotEmpty ||
        leftHandImageFile == null ||
        rightHandImageFile == null) {
      Logger.printInfo("-----------------------------");
      Logger.printInfo("|     Validation Error       |");
      Logger.printInfo("-----------------------------");
      return true;
    }
    return false;
  }

  bool _validateEditFields(BuildContext context) {
    errorNameStr = FieldValidators().fullName(
      context,
      editNameController.text.trim(),
    );
    errorDOBStr = FieldValidators().required(
      context,
      birthDateController.text.trim(),
      "Birth Date",
    );
    errorTOBStr = FieldValidators().required(
      context,
      editBirthTimeController.text.trim(),
      context.translator.timeOfBirth,
    );
    errorPlaceOfBirthStr = FieldValidators().required(
      context,
      editBirthPlaceController.text.trim(),
      context.translator.birthPlace,
    );
    errorCurrentLocationStr = FieldValidators().required(
      context,
      editCurrentLocationController.text.trim(),
      context.translator.currentLocation,
    );
    notifyListeners();

    if (errorNameStr.isNotEmpty ||
        errorCurrentLocationStr.isNotEmpty ||
        errorDOBStr.isNotEmpty ||
        errorTOBStr.isNotEmpty ||
        errorPlaceOfBirthStr.isNotEmpty) {
      Logger.printInfo("-----------------------------");
      Logger.printInfo("|     Validation Error       |");
      Logger.printInfo("-----------------------------");
      return true;
    }
    return false;
  }
}
