import 'package:flutter/foundation.dart';

class Logger {
  Logger._();

  static void printInfo(String text) {
    // if (kDebugMode) {
    print("Logger --- $text");
    // }
  }

  static void printError(String text) {
    if (kDebugMode) {
      print("Logger --- [ERROR] $text");
    }
  }
}
