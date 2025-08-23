import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'apps.dart';
import 'apps/mobile/user/services/locale_storage_service.dart';

ValueNotifier<bool> isOffline = ValueNotifier(true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([PrefHelper.init()]);
  runApp(ToastificationWrapper(child: const MyApp()));
}
