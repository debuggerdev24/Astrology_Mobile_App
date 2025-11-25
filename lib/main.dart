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
-> Debugged the provider module of the home screen to ensure proper state handling.
-> Added new attributes and logic to manage API loading states.
-> Tested and reviewed all home screen APIs to ensure proper performance.
-> Implemented error handling for API responses to prevent failures.
-> Updated shimmer loading conditions to avoid null errors.
-> Identified and fixed issues occurring on the home screen.
*/