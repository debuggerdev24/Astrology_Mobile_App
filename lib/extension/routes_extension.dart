import '../routes/mobile_routes/user_routes.dart';

extension AppRouteExtension on MobileAppRoutes {
  String get path => this == MobileAppRoutes.homeScreen ? "/" : "/$name";
}
