import 'package:astrology_app/apps/mobile/user/screens/auth/forgot_password_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/auth/otp_verfication_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/auth/sign_in_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/app_info/app_info.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/profile/profile_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/extension/routes_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:go_router/go_router.dart';

import '../../apps/mobile/user/screens/auth/sign_up_screen.dart';
import '../../apps/mobile/user/screens/settings/profile/edit_profile_screen.dart';

class MobileAppRouter {
  static final GoRouter goRouter = GoRouter(
    initialLocation: MobileAppRoutes.userDashBoardScreen.path, //
    routes: routes,
  );

  static final List<RouteBase> routes = [
    GoRoute(
      path: MobileAppRoutes.signUpScreen.path,
      name: MobileAppRoutes.signUpScreen.name,
      builder: (context, state) {
        // final String name = state.extra as String;
        return SignUpScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.signInScreen.path,
      name: MobileAppRoutes.signInScreen.name,
      builder: (context, state) {
        // final String name = state.extra as String;
        return SignInScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.forgotPasswordScreen.path,
      name: MobileAppRoutes.forgotPasswordScreen.name,
      builder: (context, state) {
        // final String name = state.extra as String;
        return ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.otpScreen.path,
      name: MobileAppRoutes.otpScreen.name,
      builder: (context, state) {
        // final String name = state.extra as String;
        return OtpVerificationScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.userDashBoardScreen.path,
      name: MobileAppRoutes.userDashBoardScreen.name,
      builder: (context, state) {
        // final String name = state.extra as String;
        return UserDashboard();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.appInfoScreen.path,
      name: MobileAppRoutes.appInfoScreen.name,
      builder: (context, state) {
        return AppInfo();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.privacyPolicyScreen.path,
      name: MobileAppRoutes.privacyPolicyScreen.name,
      builder: (context, state) {
        return AppInfo();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.profileScreen.path,
      name: MobileAppRoutes.profileScreen.name,
      builder: (context, state) {
        return ProfileScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.editProfileScreen.path,
      name: MobileAppRoutes.editProfileScreen.name,
      builder: (context, state) {
        return EditProfileScreen();
      },
    ),
  ];
}
