import 'package:astrology_app/apps/mobile/user/services/locale_storage_service.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/base_api_helper.dart';
import '../../../../core/utils/logger.dart';
import '../provider/auth/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userToken = LocaleStoaregService.userToken;
  bool isProfileCreated = LocaleStoaregService.profileCreated;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    Future.delayed(Duration(seconds: 2)).then((value) async {
      if (userToken.isNotEmpty) {
        Logger.printInfo("API Calling Started");
        final result = await BaseApiHelper.instance.checkTokenExpired();
        result.fold((l) {}, (r) async {
          if (r) {
            final res = await BaseApiHelper.instance.refreshAuthToken();
            res.fold(
              (err) {
                if (err.code == "token_not_valid") {
                  LocaleStoaregService.clearUserTokens();
                  context.goNamed(MobileAppRoutes.signUpScreen.name);
                }
              },
              (_) {
                context.read<UserAuthProvider>().decideFirstScreen(context);
              },
            );
          }
        });
        return;
      }
      context.goNamed(MobileAppRoutes.signUpScreen.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: Column());
  }
}
