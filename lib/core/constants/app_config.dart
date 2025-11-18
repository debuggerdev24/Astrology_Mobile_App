enum UserRole { customer, creator, admin }

class AppConfig {
  AppConfig._();
  static final UserRole userRole = UserRole.customer;
  static const String apiBaseurl = "http://209.38.20.86/api";
  static const String imagesBaseurl = "http://209.38.20.86/"; //
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
