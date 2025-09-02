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

//Upgrade's application-identifier entitlement string (9CD4575D6A.com.vogo.vendor1) does not match installed application's application-identifier string (BBHUT22K5W.com.vogo.vendor1); rejecting upgrade.
//Worked on creating new mantra player module for the playing history mantras.
//Worked on implementing feature for the play next or previous mantra.
//Worked on add logic for the prevent range error for the history mantra list.
//Worked on
