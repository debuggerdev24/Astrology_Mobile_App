import 'package:astrology_app/apps/mobile/user/services/auth_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/custom_toast.dart';
import '../../../../../core/utils/field_validator.dart';
import '../../../../../core/utils/pref_helper.dart';
import '../../../../../routes/mobile_routes/user_routes.dart';

class UserAuthProvider extends ChangeNotifier {
  final TextEditingController _registerNameCtr = TextEditingController();
  final TextEditingController _registerEmailCtr = TextEditingController();
  final TextEditingController _registerPasswordCtr = TextEditingController();
  final TextEditingController _registerConfirmPassCtr = TextEditingController();
  final TextEditingController _loginEmailCtr = TextEditingController();
  final TextEditingController _loginPassCtr = TextEditingController();
  final TextEditingController _forgotEmailCtr = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  TextEditingController _resetNewPassCtr = TextEditingController();
  TextEditingController _resetConfirmPassCtr = TextEditingController();

  TextEditingController get registerNameCtr => _registerNameCtr;
  TextEditingController get registerEmailCtr => _registerEmailCtr;
  TextEditingController get registerPasswordCtr => _registerPasswordCtr;
  TextEditingController get registerConfirmPassCtr => _registerConfirmPassCtr;
  TextEditingController get loginEmailCtr => _loginEmailCtr;
  TextEditingController get loginPassCtr => _loginPassCtr;
  TextEditingController get forgotEmailCtr => _forgotEmailCtr;
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
  Future<void> registerUser(BuildContext context) async {
    if (_validateRegisterData()) return;

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

        await PrefHelper.setLoggedInCustomerEmail(
          _registerEmailCtr.text.trim(),
        );
        await PrefHelper.setLoggedInCustomerPassword(
          _registerPasswordCtr.text.trim(),
        );

        context.pushNamed(MobileAppRoutes.signInScreen.name);
        _registerNameCtr.clear();
        _registerEmailCtr.clear();
        _registerPasswordCtr.clear();
        _registerConfirmPassCtr.clear();
      },
    );
  }

  //todo ---------------> login user
  Future<void> loginUser(BuildContext context) async {
    if (_validateLoginData()) return;

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
        await PrefHelper.saveUserToken(data['data']['access']);
        await PrefHelper.saveUserRefreshToken(data['data']['refresh']);
        await PrefHelper.setIsUserLoggedIn();

        await PrefHelper.setLoggedInUserEmail(_loginEmailCtr.text.trim());
        await PrefHelper.setLoggedInUserPassword(_loginPassCtr.text.trim());

        // Logger.printInfo(PrefHelper.userToken);
        context.goNamed(MobileAppRoutes.userDashBoardScreen.name);
        _loginEmailCtr.clear();
        _loginPassCtr.clear();
      },
    );
  }

  //todo ---------------> log out user
  Future<void> logOutUser(BuildContext context) async {
    final result = await UserAuthService.instance.logOutUser();

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: 'Logout Successfully');
        context.goNamed(MobileAppRoutes.signUpScreen.name);
        await PrefHelper.saveUserToken("");
        await PrefHelper.saveUserRefreshToken("");
        await PrefHelper.setIsUserLoggedIn(value: false);
        await PrefHelper.setLoggedInUserEmail("");
        await PrefHelper.setLoggedInUserPassword("");

        // Logger.printInfo(PrefHelper.userToken);
      },
    );
  }

  //todo ---------------> forgot password
  Future<void> forgotPassword(BuildContext context) async {
    final result = await UserAuthService.instance.forgetPassword(
      email: _forgotEmailCtr.text.trim(),
    );

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
      },
    );
  }

  //todo ---------------> verify OTP
  Future<void> verifyOtp({
    required BuildContext context,
    required String userId,
  }) async {
    final result = await UserAuthService.instance.verifyOtp(
      otp: _otpController.text.trim(),
      userId: userId,
    );

    result.fold(
      (failure) {
        AppToast.error(context: context, message: failure.errorMessage);
      },
      (data) async {
        AppToast.success(context: context, message: data['message']);
        context.pushNamed(
          MobileAppRoutes.resetPasswordScreen.name,
          extra: userId,
        );
      },
    );
  }

  //todo ---------------> reset password
  Future<void> resetPassword({
    required BuildContext context,
    required String userId,
  }) async {
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
      },
    );
  }

  //todo --------> validation functions for all fields are below
  bool _validateLoginData() {
    loginEmailErr = FieldValidators().email(_loginEmailCtr.text.trim()) ?? "";
    loginPassErr =
        FieldValidators().required(_loginPassCtr.text.trim(), "Password") ?? "";
    notifyListeners();

    if (loginEmailErr.isNotEmpty || loginPassErr.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool _validateRegisterData() {
    // validate name
    registerNameErr =
        FieldValidators().required(_registerNameCtr.text.trim(), "Name") ?? "";

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
