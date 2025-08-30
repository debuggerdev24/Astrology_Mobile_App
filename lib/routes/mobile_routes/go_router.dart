import 'package:astrology_app/apps/mobile/user/model/home/daily_horo_scope_model.dart';
import 'package:astrology_app/apps/mobile/user/model/settings/premium_plan_model.dart';
import 'package:astrology_app/apps/mobile/user/screens/auth/forgot_password_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/auth/otp_verfication_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/auth/reset_password_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/auth/sign_in_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/create_profile_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/home/dasha_nakshtra_details_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/mantras/mantra_player_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/premium/current_plan_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/premium/failed_payment_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/premium/payment_detail_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/premium/premium_plan_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/premium/selected_plan_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/premium/success_payment_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/birth_chart_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/palm_reading_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/palm_upload_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/remedies_list_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/remedy_detail_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/remedy_player_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/remedies/set_reminder_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/app_info/app_info.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/app_info/faq_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/app_info/privacy_policy_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/app_info/spiritual_disclaimer_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/app_info/terms_and_condition.dart';
import 'package:astrology_app/apps/mobile/user/screens/settings/profile/profile_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/splash_screen.dart';
import 'package:astrology_app/apps/mobile/user/screens/user_dashboard.dart';
import 'package:astrology_app/extension/routes_extension.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:go_router/go_router.dart';

import '../../apps/mobile/user/screens/auth/sign_up_screen.dart';
import '../../apps/mobile/user/screens/settings/profile/edit_profile_screen.dart';

class MobileAppRouter {
  static final GoRouter goRouter = GoRouter(
    initialLocation: MobileAppRoutes.splashScreen.path, //
    routes: routes,
  );

  static final List<RouteBase> routes = [
    GoRoute(
      path: MobileAppRoutes.splashScreen.path,
      name: MobileAppRoutes.splashScreen.name,
      builder: (context, state) {
        return SplashScreen();
      },
    ),
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
      path: MobileAppRoutes.verifyOtpScreen.path,
      name: MobileAppRoutes.verifyOtpScreen.name,
      builder: (context, state) {
        final String userId = state.extra as String;
        return OtpVerificationScreen(userId: userId);
      },
    ),
    GoRoute(
      path: MobileAppRoutes.resetPasswordScreen.path,
      name: MobileAppRoutes.resetPasswordScreen.name,
      builder: (context, state) {
        final String userId = state.extra as String;
        return ResetPasswordScreen(userId: userId);
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
    GoRoute(
      path: MobileAppRoutes.playMantraScreen.path,
      name: MobileAppRoutes.playMantraScreen.name,
      builder: (context, state) {
        final data = state.extra as Map;
        return MantraPlayScreen(data: data);
      },
    ),

    GoRoute(
      path: MobileAppRoutes.palmReadingScreen.path,
      name: MobileAppRoutes.palmReadingScreen.name,
      builder: (context, state) {
        return PalmReadingScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.birthChartScreen.path,
      name: MobileAppRoutes.birthChartScreen.name,
      builder: (context, state) {
        return BirthChartScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.palmUploadScreen.path,
      name: MobileAppRoutes.palmUploadScreen.name,
      builder: (context, state) {
        return PalmUploadScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.remediesListScreen.path,
      name: MobileAppRoutes.remediesListScreen.name,
      builder: (context, state) {
        return RemediesScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.remedyDetailsScreen.path,
      name: MobileAppRoutes.remedyDetailsScreen.name,
      builder: (context, state) {
        return RemedyDetailScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.setReminderScreen.path,
      name: MobileAppRoutes.setReminderScreen.name,
      builder: (context, state) {
        return SetReminderScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.remedyPlayerScreen.path,
      name: MobileAppRoutes.remedyPlayerScreen.name,
      builder: (context, state) {
        final bool isText = state.extra as bool;
        return RemedyPlayerScreen(isText: isText);
      },
    ),
    GoRoute(
      path: MobileAppRoutes.premiumPlanScreen.path,
      name: MobileAppRoutes.premiumPlanScreen.name,
      builder: (context, state) {
        return PremiumPlanScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.selectedPlanScreen.path,
      name: MobileAppRoutes.selectedPlanScreen.name,
      builder: (context, state) {
        final SubscriptionPlanModel plan = state.extra as SubscriptionPlanModel;
        return SelectedPlanScreen(plan: plan);
      },
    ),
    GoRoute(
      path: MobileAppRoutes.paymentDetailScreen.path,
      name: MobileAppRoutes.paymentDetailScreen.name,
      builder: (context, state) {
        return PaymentDetailScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.successPaymentScreen.path,
      name: MobileAppRoutes.successPaymentScreen.name,
      builder: (context, state) {
        return SuccessPaymentScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.failedPaymentScreen.path,
      name: MobileAppRoutes.failedPaymentScreen.name,
      builder: (context, state) {
        return FailedPaymentScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.currentPlanScreen.path,
      name: MobileAppRoutes.currentPlanScreen.name,
      builder: (context, state) {
        return CurrentPlanScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.faqScreen.path,
      name: MobileAppRoutes.faqScreen.name,
      builder: (context, state) {
        return FaqScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.termsAndConditionScreen.path,
      name: MobileAppRoutes.termsAndConditionScreen.name,
      builder: (context, state) {
        return TermsAndCondition();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.spiritualDisclaimerScreen.path,
      name: MobileAppRoutes.spiritualDisclaimerScreen.name,
      builder: (context, state) {
        return SpiritualDisclaimerScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.privacyPolicyScreen.path,
      name: MobileAppRoutes.privacyPolicyScreen.name,
      builder: (context, state) {
        return PrivacyPolicyScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.createProfileScreen.path,
      name: MobileAppRoutes.createProfileScreen.name,
      builder: (context, state) {
        return CreateProfileScreen();
      },
    ),
    GoRoute(
      path: MobileAppRoutes.dashaNakshatraDetailsScreen.path,
      name: MobileAppRoutes.dashaNakshatraDetailsScreen.name,
      builder: (context, state) {
        final DailyHoroScopeModel dailyHoroScope =
            state.extra as DailyHoroScopeModel;
        return DashaNakshtraDetailsScreen(dailyHoroScope: dailyHoroScope);
      },
    ),
  ];
}
