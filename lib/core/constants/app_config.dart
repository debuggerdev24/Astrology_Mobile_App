enum UserRole { customer, creator, admin }

class AppConfig {
  AppConfig._();
  static final UserRole userRole = UserRole.customer;
  static const String apiBaseurl = "http://170.64.218.78/api";
  static const String imagesBaseurl = "http://170.64.218.78/"; //
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
