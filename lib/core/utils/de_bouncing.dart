import 'dart:async';

import 'package:flutter/material.dart';

DeBouncer deBouncer = DeBouncer(milliSecond: 500);
DeBouncer fieldDeBouncer = DeBouncer(milliSecond: 600);

class DeBouncer {
  final int milliSecond;
  Timer? timer;

  DeBouncer({required this.milliSecond});

  void run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    timer = Timer(Duration(milliseconds: milliSecond), action);
  }
}
