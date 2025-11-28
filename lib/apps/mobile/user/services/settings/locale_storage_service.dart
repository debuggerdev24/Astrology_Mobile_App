import 'package:shared_preferences/shared_preferences.dart';

class LocaleStoaregService {
  LocaleStoaregService._();

  static late SharedPreferences _pref;
  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static const String _userTokenKey = "user_token";
  static const String _userRefreshTokenKey = "user_refresh_token";
  static const String _isUserLoggedInKey = "is_user_logged_in";
  static const String _loggedInUserEmailKey = "logged_in_user_email";
  static const String _loggedInUserNameKey = "logged_in_user_name";
  static const String _loggedInUserPasswordKey = "logged_in_user_password";
  static const String _loggedInCustomerEmailKey = "logged_in_user_email";
  static const String _loggedInCustomerpasswrodKey = "logged_in_user_password";
  static const String _isProfileCreated = "is_profile_created";
  static const String _localeCode = "locale_code";
  static const String _isLanguageSelected = "is_language_selected";
  static const String _isFirstTime = "is_First_Time";

  // save and get the value of is user logged in
  static bool get isLanguageSelected =>
      _pref.getBool(_isLanguageSelected) ?? false;
  static Future<void> setIsLanguageSelected({bool value = true}) async =>
      await _pref.setBool(_isLanguageSelected, value);

  static bool get isUserLoggedIn => _pref.getBool(_isUserLoggedInKey) ?? false;
  static Future<void> setIsUserLoggedIn({bool value = true}) async =>
      await _pref.setBool(_isUserLoggedInKey, value);

  // save and get the user auth token
  static String get userToken => _pref.getString(_userTokenKey) ?? "";
  static Future<void> saveUserToken(String value) async =>
      await _pref.setString(_userTokenKey, value);

  // get logged in user email and password
  static String get loggedInUserEmail =>
      _pref.getString(_loggedInUserEmailKey) ?? '';
  static Future<void> setLoggedInUserEmail(String value) async =>
      await _pref.setString(_loggedInUserEmailKey, value);

  // get logged in user name
  static String get loggedInUserName =>
      _pref.getString(_loggedInUserNameKey) ?? '';
  static Future<void> setLoggedInUserName(String value) async =>
      await _pref.setString(_loggedInUserNameKey, value);

  static String get loggedInUserPassword =>
      _pref.getString(_loggedInUserPasswordKey) ?? '';
  static Future<void> setLoggedInUserPassword(String value) async =>
      await _pref.setString(_loggedInUserPasswordKey, value);

  static bool get isFirstTime =>
      _pref.getBool(_loggedInUserPasswordKey) ?? true;
  static Future<void> setIsFirstTime(bool value) async =>
      await _pref.setBool(_loggedInUserPasswordKey, value);

  // save and get the user refresh auth token
  static String get userRefreshToken =>
      _pref.getString(_userRefreshTokenKey) ?? '';
  static Future<void> saveUserRefreshToken(String value) async =>
      await _pref.setString(_userRefreshTokenKey, value);

  // get logged in customer email and password
  static String get loggedIncustomerEmail =>
      _pref.getString(_loggedInCustomerEmailKey) ?? '';
  static Future<void> setLoggedInCustomerEmail(String value) async =>
      await _pref.setString(_loggedInCustomerEmailKey, value);
  static String get loggedIncustomerPassword =>
      _pref.getString(_loggedInCustomerpasswrodKey) ?? '';
  static Future<void> setLoggedInCustomerPassword(String value) async =>
      await _pref.setString(_loggedInCustomerpasswrodKey, value);

  // check is profile crested or not.
  static bool get profileCreated => _pref.getBool(_isProfileCreated) ?? false;
  static Future<void> setProfileCreated(bool value) async =>
      await _pref.setBool(_isProfileCreated, value);

  static String get localeCode => _pref.getString(_localeCode) ?? "en";
  static Future<void> setLocaleCode(String code) async =>
      await _pref.setString(_localeCode, code);

  static Future<void> clearUserTokens() async {
    await _pref.remove(_userTokenKey);
    await _pref.remove(_userRefreshTokenKey);
  }
}
