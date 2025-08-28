import 'package:astrology_app/apps/mobile/user/services/settings/locale_storage_service.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/base_api_helper.dart';
import '../../../../core/network/end_points.dart';

class UserAuthService {
  UserAuthService._();

  static final UserAuthService _instance = UserAuthService._();
  static UserAuthService instance = _instance;

  Future<Either<ApiException, Map<String, dynamic>>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await BaseApiHelper.instance.post(
      Endpoints.userLogin,
      data: {"email": email, "password": password},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> registerUser({
    required String email,
    required String fullName,
    required String password,
    required String confirmPassword,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      Endpoints.userRegister,
      data: {
        'email': email.trim(),
        'full_name': fullName.trim(),
        'password': password.trim(),
        'confirm_password': confirmPassword.trim(),
      },
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> logOutUser() async {
    return await BaseApiHelper.instance.post(
      Endpoints.userLogout,
      data: {"refresh": LocaleStoaregService.userRefreshToken},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> sendOtp({
    required String email,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      Endpoints.userForgotPass,
      data: {'email': email},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      // "${Endpoints.userVerifyForgotPassToken}/$userId/",
      Endpoints.userVerifyForgotPassToken(userId: userId),
      data: {'reset_token': otp},
    );
  }

  Future<Either<ApiException, Map<String, dynamic>>> resetPassword({
    required String userId,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await BaseApiHelper.instance.post<Map<String, dynamic>>(
      // "${Endpoints.userVerifyForgotPassToken}/$userId/",
      Endpoints.resetPassWord(userId: userId),
      data: {"new_password": newPassword, "confirm_password": confirmPassword},
    );
  }

  // Future<Either<ApiException, Map<String, dynamic>>> loginCustomer({
  //   required String email,
  //   required String password,
  // }) async {
  //   return await BaseApiHelper.instance.post<Map<String, dynamic>>(
  //     Endpoints.login,
  //     data: {'email': email.trim(), 'password': password.trim()},
  //   );
  // }
  //

  //

  //
  // Future<Either<ApiException, Map<String, dynamic>>> resendOtp({
  //   required String email,
  // }) async {
  //   return await BaseApiHelper.instance.post<Map<String, dynamic>>(
  //     Endpoints.customerResendOtp,
  //     data: {'email': email.trim()},
  //   );
  // }
  //
  // Future<Either<ApiException, Map<String, dynamic>>> getNationalityList() async {
  //   return await BaseApiHelper.instance.get<Map<String, dynamic>>(
  //     Endpoints.registerCustomerNationality,
  //   );
  // }
}
