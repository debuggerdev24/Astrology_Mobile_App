import 'package:astrology_app/apps/mobile/user/services/locale_storage_service.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userToken = PrefHelper.userToken;
  bool isProfileCreated = PrefHelper.profileCreated;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      if (userToken.isNotEmpty) {
        context.goNamed(
          (isProfileCreated)
              ? MobileAppRoutes.userDashBoardScreen.name
              : MobileAppRoutes.createProfileScreen.name,
        );
        return;
      }
      context.goNamed(MobileAppRoutes.signUpScreen.name);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: Column());
  }
}
