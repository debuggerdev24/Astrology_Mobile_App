enum UserRole { customer, creator, admin }

class AppConfig {
  AppConfig._();
  static final UserRole userRole = UserRole.customer;
  static const String apiBaseurl = "http://138.197.92.15/astro/api";
  static const String imagesBaseurl = "http://138.197.92.15/astro"; //
}

/*
test customer details 
---------------------
email: jhonsmith@mailinator.com
pass: Pass@123
mobile no: 1234567890
nationality: indian
gender: male
*/
