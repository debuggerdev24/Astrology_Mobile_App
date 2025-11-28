import 'dart:async';

import 'package:astrology_app/apps/mobile/user/provider/setting/subscription_provider.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/apps/mobile/user/services/auth/auth_api_service.dart';
import 'package:astrology_app/core/enum/app_enums.dart';
import 'package:astrology_app/core/extension/context_extension.dart';
import 'package:astrology_app/core/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/field_validator.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';
import '../../services/settings/locale_storage_service.dart';
import '../../services/settings/profile_api_service.dart';

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
  String _currentEmail = '';
  Timer? _resendTimer;
  int _resendSeconds = 0;
  bool _firstTime = false;
  bool get isFirstTime => _firstTime;
  bool get canResendOtp => _resendSeconds == 0;

  // Add getter for remaining time
  int get resendSeconds => _resendSeconds;

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
        AppToast.success(
          context: context,
          message: context.translator.registeredSuccessfully,
        );
        await LocaleStoaregService.setLoggedInCustomerEmail(
          _registerEmailCtr.text.trim(),
        );
        await LocaleStoaregService.setLoggedInCustomerPassword(
          _registerPasswordCtr.text.trim(),
        );

        context.pushNamed(MobileAppRoutes.signInScreen.name);
        await LocaleStoaregService.setLoggedInUserName(
          _registerNameCtr.text.trim(),
        );
        clearRegisterField();
        clearLoginFields();
      },
    );
    isRegisterLoading = false;
    notifyListeners();
  }

  clearRegisterField() {
    _registerNameCtr.clear();
    _registerEmailCtr.clear();
    _registerPasswordCtr.clear();
    _registerConfirmPassCtr.clear();
  }

  clearRegisterErrors() {
    registerNameErr = registerEmailErr = registerPasswordErr =
        registerConfirmPassWordErr = "";
  }

  //todo ---------------> login user
  bool isLoginLoading = false;
  Future<void> loginUser(BuildContext context) async {
    if (_validateLoginData(context)) return;
    isLoginLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.loginWithEmailPassword(
      email: loginEmailCtr.text.trim(),
      password: loginPassCtr.text.trim(),
    );

    result.fold(
      (failure) {
        Logger.printInfo(failure.errorMessage);

        AppToast.error(
          context: context,
          message: (failure.errorMessage == "Invalid email or password")
              ? context.translator.accNotFoundError
              : failure.errorMessage,
        );
      },
      (data) async {
        AppToast.success(
          context: context,
          message: context.translator.loginSuccessfully,
        );
        _firstTime = data["data"]["first_time"];
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
        await decideFirstScreen(context);
        _loginEmailCtr.clear();
        _loginPassCtr.clear();
      },
    );
    isLoginLoading = false;
    notifyListeners();
  }

  void clearLoginFields() {
    _loginEmailCtr.clear();
    _loginPassCtr.clear();
  }

  void clearLoginError() {
    loginEmailErr = loginPassErr = forgotEmailErr = "";
  }

  Future<void> decideFirstScreen(BuildContext context) async {
    final result = await UserProfileService.instance.getProfile();
    result.fold(
      (l) async {
        if (!LocaleStoaregService.isLanguageSelected) {
          context.goNamed(MobileAppRoutes.selectLanguageScreen.name);
          return;
        }
        await LocaleStoaregService.saveUserToken("");
        await LocaleStoaregService.saveUserRefreshToken("");
        context.pushNamed(MobileAppRoutes.signUpScreen.name);
      },
      (r) {
        final data = r["data"]["palm_image_left"];
        Logger.printInfo("---------------> ${data.toString()}");
        if (!LocaleStoaregService.isLanguageSelected) {
          context.goNamed(MobileAppRoutes.selectLanguageScreen.name);
          return;
        }
        if (data == null) {
          Logger.printInfo(
            "Going to the profile screen by using your new logic",
          );
          context.goNamed(MobileAppRoutes.createProfileScreen.name);
          return;
        }
        LocaleStoaregService.setProfileCreated(true);
        print("sjbcvhjdbvhbvhbdff");

        context.goNamed(MobileAppRoutes.userDashBoardScreen.name);
      },
    );
  }

  //todo ---------------> log out
  bool isLogOutLoading = false;

  // Future<void> logOutUser(BuildContext context) async {
  //   isLogOutLoading = true;
  //   notifyListeners();
  //   final result = await UserAuthService.instance.logOutUser();
  //
  //   result.fold(
  //     (failure) {
  //       AppToast.error(context: context, message: failure.errorMessage);
  //     },
  //     (data) async {
  //       AppToast.success(context: context, message: 'Logged out successfully.');
  //       Future.microtask(() {
  //         context.goNamed(MobileAppRoutes.signUpScreen.name);
  //       });
  //       await LocaleStoaregService.saveUserToken("");
  //       await LocaleStoaregService.saveUserRefreshToken("");
  //       await LocaleStoaregService.setIsUserLoggedIn(value: false);
  //       await LocaleStoaregService.setLoggedInUserEmail("");
  //       await LocaleStoaregService.setLoggedInUserPassword("");
  //       indexTabUser.value = 0;
  //     },
  //   );
  //   isLogOutLoading = false;
  //   notifyListeners();
  // }

  Future<void> logOutUser(BuildContext context) async {
    isLogOutLoading = true;
    notifyListeners();
    final result = await UserAuthService.instance.logOutUser();

    result.fold(
      (failure) {
        if (context.mounted) {
          AppToast.error(context: context, message: failure.errorMessage);
        }
      },
      (data) async {
        if (context.mounted) {
          AppToast.success(
            context: context,
            message: context.translator.loggedOutSuccessfully,
          );
          context.read<SubscriptionProvider>().removeSubscription(
            AppEnum.tier1,
          );
          context.read<SubscriptionProvider>().removeSubscription(
            AppEnum.tier2,
          );
        }

        await LocaleStoaregService.saveUserToken("");
        await LocaleStoaregService.saveUserRefreshToken("");
        await LocaleStoaregService.setIsUserLoggedIn(value: false);
        await LocaleStoaregService.setProfileCreated(false);

        await LocaleStoaregService.setLoggedInUserEmail("");
        await LocaleStoaregService.setLoggedInUserPassword("");
        indexTabUser.value = 0;

        // Navigate after clearing storage and only if context is still mounted
        if (context.mounted) {
          context.goNamed(MobileAppRoutes.signUpScreen.name);
        }
      },
    );
    isLogOutLoading = false;
    notifyListeners();
  }

  //todo ---------------> forgot password
  void _startResendTimer() {
    _resendSeconds = 60; // 1 minute
    notifyListeners();

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        notifyListeners();
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  bool isSendOtpLoading = false;
  Future<void> sendOtp({
    required BuildContext context,
    required String email,
  }) async {
    forgotEmailErr = FieldValidators().email(email, context);
    notifyListeners();

    if (forgotEmailErr.isEmpty) {
      isSendOtpLoading = true;
      notifyListeners();
      final result = await UserAuthService.instance.sendOtp(email: email);

      result.fold(
        (failure) {
          AppToast.error(context: context, message: failure.errorMessage);
        },
        (data) async {
          AppToast.success(
            context: context,
            message: context.translator.otpSentSuccessfully,
          );
          Logger.printInfo(data['message']);
          // Store email for resend functionality
          _currentEmail = email;

          // Start the timer
          _startResendTimer();

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
  }

  bool isResendOtpLoading = false;
  Future<void> resendOtp({required BuildContext context}) async {
    if (!canResendOtp) {
      AppToast.error(
        context: context,
        message: "Please wait $_resendSeconds seconds before resending",
      );
      return;
    }

    if (_currentEmail.isEmpty) {
      AppToast.error(
        context: context,
        message: "Email not found. Please try again.",
      );
      return;
    }

    isResendOtpLoading = true;
    notifyListeners();

    final result = await UserAuthService.instance.sendOtp(email: _currentEmail);

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(
          context: context,
          message: context.translator.otpSentSuccessfully,
        ); //"OTP resent successfully"
        _otpController.clear();
        // Restart the timer after successful resend
        _startResendTimer();
      },
    );

    isResendOtpLoading = false;
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
    // clearResetPassError()
    resetNewPassErr = "";
    resetConfirmPassErr = "";

    result.fold(
      (failure) {
        if (failure.errorMessage.contains("expired")) {
          AppToast.error(
            context: context,
            message: context.translator.expireToken,
          );
          return;
        }
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(
          context: context,
          message: context.translator.otpVerifiedSuccessfully,
        );
        context.pushNamed(
          MobileAppRoutes.resetPasswordScreen.name,
          extra: userId,
        );
        _resetNewPassCtr.clear();
        _resetConfirmPassCtr.clear();
        resetNewPassErr = "";
        resetConfirmPassErr = "";
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
    if (_validateResetPasswordData(context)) return;
    isResetPasswordLoading = true;
    notifyListeners();
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
        AppToast.success(
          context: context,
          message: context.translator.passwordResetSuccessfully,
        );
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
  bool _validateLoginData(BuildContext context) {
    loginEmailErr = FieldValidators().email(
      _loginEmailCtr.text.trim(),
      context,
    );
    loginPassErr = FieldValidators().required(
      context,
      _loginPassCtr.text.trim(),
      context.translator.password,
    );
    // _loginPassCtr.text.trim().isEmpty
    //     ? "Password is Required"
    //     : "";
    notifyListeners();

    if (loginEmailErr.isNotEmpty || loginPassErr.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _validateRegisterData(BuildContext context) {
    // validate name
    registerNameErr = FieldValidators().fullName(
      context,
      _registerNameCtr.text.trim(),
    );

    // validate email
    registerEmailErr = FieldValidators().email(
      _registerEmailCtr.text.trim(),
      context,
    );

    // validate password
    registerPasswordErr = FieldValidators().password(
      _registerPasswordCtr.text.trim(),
      context,
    );

    // validate confirm password

    registerConfirmPassWordErr = FieldValidators().match(
      _registerConfirmPassCtr.text.trim(),
      _registerPasswordCtr.text.trim(),
      context, //"Confirm Password should match with Password!",
    );

    // if (FieldValidators().match(
    //       _registerConfirmPassCtr.text.trim(),
    //       _registerPasswordCtr.text.trim(),
    //       "Password dosen't match",
    //     ) !=
    //     null) {
    //   !;
    // } else {
    //   registerConfirmPassWordErr = "";
    // }

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

  void clearResetPassError() {}

  bool _validateResetPasswordData(BuildContext context) {
    resetNewPassErr = FieldValidators().password(
      _resetNewPassCtr.text.trim(),
      context,
    );
    resetConfirmPassErr = FieldValidators().match(
      _resetConfirmPassCtr.text.trim(),
      _resetNewPassCtr.text.trim(),
      context, //"Confirm Password should match with Password!",
    );

    notifyListeners();

    if (resetNewPassErr.isNotEmpty || resetConfirmPassErr.isNotEmpty) {
      return true;
    }
    return false;
  }
}
