import 'package:animate_do/animate_do.dart';
import 'package:astrology_app/core/constants/text_style.dart';
import 'package:astrology_app/core/widgets/app_layout.dart';
import 'package:astrology_app/core/widgets/app_text.dart';
import 'package:astrology_app/main.dart';
import 'package:astrology_app/routes/mobile_routes/user_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/network/base_api_helper.dart';
import '../../../../../core/utils/logger.dart';
import '../../provider/auth/auth_provider.dart';
import '../../services/settings/locale_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userToken = LocaleStorageService.userToken;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    Logger.printInfo("Authorized Token : $userToken /");

    Future.delayed(Duration(seconds: 3)).then((value) async {
      // context.pushNamed(MobileAppRoutes.signUpScreen.name);
      // SubscriptionService().initialize(context);
      if (!isNetworkConnected.value) {
        context.pushNamed(MobileAppRoutes.userDashBoardScreen.name);
        return;
      }
      if (userToken.isNotEmpty) {
        Logger.printInfo("API Calling Started");
        final result = await BaseApiHelper.instance.checkTokenExpired();

        result.fold((l) {}, (r) async {
          Logger.printInfo("token output $r");
          if (r) {
            final res = await BaseApiHelper.instance.refreshAuthToken();
            res.fold(
              (err) async {
                if (err.code == "token_not_valid") {
                  await LocaleStorageService.saveUserToken("");
                  await LocaleStorageService.saveUserRefreshToken("");
                  context.goNamed(MobileAppRoutes.signUpScreen.name);
                }
              },
              (_) {
                context.read<UserAuthProvider>().decideFirstScreen(context);
              },
            );
            return;
          } else {
            context.read<UserAuthProvider>().decideFirstScreen(context);
            return;
          }
        });
        return;
      }
      if (!LocaleStorageService.isLanguageSelected) {
        context.goNamed(MobileAppRoutes.selectLanguageScreen.name);
        return;
      }
      context.goNamed(MobileAppRoutes.signUpScreen.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: Center(
        child: ZoomIn(
          from: 1,
          duration: Duration(seconds: 2),
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 95,
                width: 95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(AppAssets.appLogo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppText(text: "Inner Peace Path", style: regular(fontSize: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
