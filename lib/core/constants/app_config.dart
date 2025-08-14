enum UserRole { customer, creator, admin }

class AppConfig {
  AppConfig._();
  static final UserRole userRole = UserRole.customer;
  static const String apiBaseurl = "https://api.noted.ae/api/";
  static const String imagesBaseurl = "https://api.noted.ae"; //
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
