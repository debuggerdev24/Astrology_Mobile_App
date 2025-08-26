import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'mobile_app.dart';

Future<void> checkConnectivity() async {
  Connectivity().onConnectivityChanged.listen((
    List<ConnectivityResult> results,
  ) {
    if (results.contains(ConnectivityResult.none)) {
      isNetworkConnected.value = false;
    } else {
      isNetworkConnected.value = true;
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    checkConnectivity();
    return ValueListenableBuilder(
      valueListenable: isNetworkConnected,

      builder: (context, value, child) {
        return AstrologyMobileApp();
      },
    );
  }
}
