import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/apps/mobile/user/services/auth_api_service.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/field_validator.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../services/locale_storage_service.dart';
import '../../services/profile_api_service.dart';

class UserAuthProvider extends ChangeNotifier {
  final TextEditingController _registerNameCtr = TextEditingController();
  final TextEditingController _registerEmailCtr = TextEditingController();
  final TextEditingController _registerPasswordCtr = TextEditingController();
  final TextEditingController _registerConfirmPassCtr = TextEditingController();
  final TextEditingController _loginEmailCtr = TextEditingController();
  final TextEditingController _loginPassCtr = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _resetNewPassCtr = TextEditingController();
  final TextEditingController _resetConfirmPassCtr = TextEditingController();

  TextEditingController get registerNameCtr => _registerNameCtr;
  TextEditingController get registerEmailCtr => _registerEmailCtr;
  TextEditingController get registerPasswordCtr => _registerPasswordCtr;
  TextEditingController get registerConfirmPassCtr => _registerConfirmPassCtr;
  TextEditingController get loginEmailCtr => _loginEmailCtr;
  TextEditingController get loginPassCtr => _loginPassCtr;
  TextEditingController get otpController => _otpController;
  TextEditingController get resetNewPassCtr => _resetNewPassCtr;
  TextEditingController get resetConfirmPassCtr => _resetConfirmPassCtr;

  String registerEmailErr = '';
  String registerNameErr = '';
  String registerMobileNumberErr = '';
  String registerPasswordErr = '';
  String registerConfirmPassWordErr = '';
  String forgotEmailErr = '';
  String resetNewPassErr = '';
  String resetConfirmPassErr = '';

  String loginEmailErr = '';
  String loginPassErr = '';

  //todo ---------------> register user
  bool isRegisterLoading = false;
  Future<void> registerUser(BuildContext context) async {
    if (_validateRegisterData(context)) return;
    isRegisterLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.registerUser(
      email: _registerEmailCtr.text,
      fullName: _registerNameCtr.text,
      password: _registerPasswordCtr.text,
      confirmPassword: _registerConfirmPassCtr.text,
    );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: 'Registered Successfully');

        await LocaleStoaregService.setLoggedInCustomerEmail(
          _registerEmailCtr.text.trim(),
        );
        await LocaleStoaregService.setLoggedInCustomerPassword(
          _registerPasswordCtr.text.trim(),
        );

        context.pushNamed(MobileAppRoutes.signInScreen.name);
        _registerNameCtr.clear();
        _registerEmailCtr.clear();
        _registerPasswordCtr.clear();
        _registerConfirmPassCtr.clear();
      },
    );
    isRegisterLoading = false;
    notifyListeners();
  }

  //todo ---------------> login user
  bool isLoginLoading = false;
  Future<void> loginUser(BuildContext context) async {
    if (_validateLoginData()) return;
    isLoginLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.loginWithEmailPassword(
      email: loginEmailCtr.text.trim(),
      password: loginPassCtr.text.trim(),
    );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: 'Login Successfully');
        await LocaleStoaregService.saveUserToken(data['data']['access']);

        await LocaleStoaregService.saveUserRefreshToken(
          data['data']['refresh'],
        );

        await LocaleStoaregService.setIsUserLoggedIn();

        await LocaleStoaregService.setLoggedInUserEmail(
          _loginEmailCtr.text.trim(),
        );
        await LocaleStoaregService.setLoggedInUserPassword(
          _loginPassCtr.text.trim(),
        );

        decideFirstScreen(context);
        // Logger.printInfo(PrefHelper.userToken);

        _loginEmailCtr.clear();
        _loginPassCtr.clear();
      },
    );
    isLoginLoading = false;
    notifyListeners();
  }

  Future<void> decideFirstScreen(BuildContext context) async {
    final result = await UserProfileService.instance.getProfile();
    result.fold((l) {}, (r) {
      final data = r["data"]["palm_image_left"];

      if (data == null) {
        Logger.printInfo(
          "Going to the profile screen by using yoiur new logic",
        );
        context.goNamed(MobileAppRoutes.createProfileScreen.name);
        return;
      }
      context.goNamed(MobileAppRoutes.userDashBoardScreen.name);
    });
  }

  //todo ---------------> log out
  bool isLogOutLoading = false;

  Future<void> logOutUser(BuildContext context) async {
    isLogOutLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.logOutUser();

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: 'Logged out successfully.');
        context.goNamed(MobileAppRoutes.signUpScreen.name);
        await LocaleStoaregService.saveUserToken("");
        await LocaleStoaregService.saveUserRefreshToken("");
        await LocaleStoaregService.setIsUserLoggedIn(value: false);
        await LocaleStoaregService.setLoggedInUserEmail("");
        await LocaleStoaregService.setLoggedInUserPassword("");
        indexTabUser.value = 0;

        // Logger.printInfo(PrefHelper.userToken);
      },
    );
    isLogOutLoading = false;
    notifyListeners();
  }

  //todo ---------------> forgot password
  bool isSendOtpLoading = false;
  Future<void> sendOtp({
    required BuildContext context,
    required String email,
  }) async {
    isSendOtpLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.sendOtp(email: email);

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: data['message']);

        context.pushNamed(
          MobileAppRoutes.verifyOtpScreen.name,
          extra: (data["data"]["user_id"] as int).toString(),
        );
        _otpController.clear();
      },
    );
    isSendOtpLoading = false;
    notifyListeners();
  }

  //todo ---------------> verify OTP
  bool isOtpVerificationLoading = false;
  Future<void> verifyOtp({
    required BuildContext context,
    required String userId,
  }) async {
    isOtpVerificationLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.verifyOtp(
      otp: _otpController.text.trim(),
      userId: userId,
    );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(
          context: context,
          message: "OTP verified successfully",
        );
        context.pushNamed(
          MobileAppRoutes.resetPasswordScreen.name,
          extra: userId,
        );
        _resetNewPassCtr.clear();
        _resetConfirmPassCtr.clear();
      },
    );
    isOtpVerificationLoading = false;
    notifyListeners();
  }

  //todo ---------------> reset password
  bool isResetPasswordLoading = false;
  Future<void> resetPassword({
    required BuildContext context,
    required String userId,
  }) async {
    isResetPasswordLoading = true;
    notifyListeners();
    // if (_validateResetPasswordData()) return;
    final result = await UserAuthService.instance.resetPassword(
      userId: userId,
      newPassword: _resetNewPassCtr.text.trim(),
      confirmPassword: _resetConfirmPassCtr.text.trim(),
    );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: data['message']);
        context.pop();
        context.pop();
        context.pop();
        _resetNewPassCtr.clear();
        _resetConfirmPassCtr.clear();
      },
    );
    isResetPasswordLoading = false;
    notifyListeners();
  }

  //todo --------> validation functions for all fields are below
  bool _validateLoginData() {
    loginEmailErr = FieldValidators().email(_loginEmailCtr.text.trim()) ?? "";
    loginPassErr = _loginPassCtr.text.trim().isEmpty
        ? "Password is Required"
        : "";
    notifyListeners();

    if (loginEmailErr.isNotEmpty || loginPassErr.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _validateRegisterData(BuildContext context) {
    // validate name
    registerNameErr =
        FieldValidators().fullName(context, _registerNameCtr.text.trim()) ?? "";

    // validate email
    registerEmailErr =
        FieldValidators().email(_registerEmailCtr.text.trim()) ?? "";

    // validate password
    registerPasswordErr =
        FieldValidators().password(_registerPasswordCtr.text.trim()) ?? "";

    // validate confirm password
    if (FieldValidators().match(
          _registerConfirmPassCtr.text.trim(),
          _registerPasswordCtr.text.trim(),
          "Password dosen't match",
        ) !=
        null) {
      registerConfirmPassWordErr = FieldValidators().match(
        _registerConfirmPassCtr.text.trim(),
        _registerPasswordCtr.text.trim(),
        "Password not matched!",
      )!;
    } else {
      registerConfirmPassWordErr = "";
    }

    notifyListeners();

    if (registerNameErr.isNotEmpty ||
        registerEmailErr.isNotEmpty ||
        registerMobileNumberErr.isNotEmpty ||
        registerPasswordErr.isNotEmpty ||
        registerConfirmPassWordErr.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool _validateResetPasswordData() {
    resetNewPassErr =
        FieldValidators().password(_resetNewPassCtr.text.trim()) ?? "";
    resetConfirmPassErr =
        (_resetNewPassCtr.text.trim() == _resetConfirmPassCtr.text.trim())
        ? ""
        : "Password not matched";

    notifyListeners();

    if (loginEmailErr.isNotEmpty || loginPassErr.isNotEmpty) {
      return true;
    }
    return false;
  }
}
