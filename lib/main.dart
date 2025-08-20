import 'package:flutter/material.dart';

import 'apps.dart';


ValueNotifier<bool> isOffline = ValueNotifier(true);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
