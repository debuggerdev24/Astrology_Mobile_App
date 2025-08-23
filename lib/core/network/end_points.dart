class Endpoints {
  Endpoints._();

  static const String checkTokenExpired = '/accounts/user-profile/';
  static const String userLogin = '/accounts/login/';
  static const String userRegister = '/accounts/register/user/';
  static const String userForgotPass = '/accounts/forgot-password/';
  static String userVerifyForgotPassToken({required String userId}) =>
      '/accounts/verify-reset-token/$userId/';
  static String resetPassWord({required String userId}) =>
      '/accounts/reset-password/$userId/';
  static const String userResetPassword = '/accounts/reset-password/2/';
  static const String userGetProfile = '/accounts/user-profile/';
  static const String userEditProfile = '/accounts/user-edit-profile/';
  static const String refreshToken = '/accounts/token/refresh/';
  static const String userLogout = '/accounts/logout/';
  static const String editProfile = '/accounts/user-edit-profile/';
  static const String getProfile = '/accounts/user-profile/';
}
