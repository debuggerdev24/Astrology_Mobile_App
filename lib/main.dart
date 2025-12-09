import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

import 'apps.dart';
import 'apps/mobile/user/services/settings/locale_storage_service.dart';

ValueNotifier<bool> isNetworkConnected = ValueNotifier(true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Future.wait([LocaleStoaregService.init()]);
  runApp(ToastificationWrapper(child: const MyApp()));
}

//todo app changes :
/*

todo Vimaal

sandbox password:
-> Test.dds123@

todo vimal

*/
