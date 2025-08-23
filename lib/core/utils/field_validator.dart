class FieldValidators {
  FieldValidators._();

  static final FieldValidators _instance = FieldValidators._();

  factory FieldValidators() => _instance;

  String? required(String? val, String fieldName) {
    if (val == null || val.isEmpty) {
      return "$fieldName is Required!";
    }
    return null;
  }

  String fullName(String? val) {
    RegExp namePattern = RegExp(r"^[A-Za-z]+(?: [A-Za-z]+)*$");

    if (val == null || val.isEmpty) {
      return "Name is required.";
    }

    if (!namePattern.hasMatch(val) && val.isNotEmpty) {
      return "Enter a valid name (Only alphabets allowed).";
    }

    return "";
  }

  String? email(String? val) {
    if (val!.isEmpty) {
      return 'Email is required!';
    }

    RegExp emailPattern = RegExp(
      r'^[a-z0-9!@#$%^&*_(),.?":{}|<>]+@(gmail\.com|mailinator\.com)$',
    );

    if (!emailPattern.hasMatch(val ?? "")) {
      return "Enter valid Email!";
    }
    return null;
  }

  String? password(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required!';
    }

    RegExp passwordPattern = RegExp(
      r"""^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>])(?=.*[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>]).{8,}$""",
    );

    if (!passwordPattern.hasMatch(val)) {
      return "Password must be at least 8 characters, include a capital letter, a number, and a special character!";
    }
    return null;
  }

  String? maxLength(String? val, int max) {
    if (val == null || val.isEmpty) {
      return null;
    }
    // No,only api integraton the task is below which i have perform tody

    if (val.length > max) {
      return "Field must not exceed $max characters!";
    }
    return null;
  }

  String? minLength(String? val, int min) {
    if (val == null || val.isEmpty) {
      return null;
    }

    if (val.length < min) {
      return "Field must be at least $min characters!";
    }
    return null;
  }

  String? pattern(String? val, String pattern, String errorMessage) {
    if (val == null || val.isEmpty) {
      return null;
    }

    if (!RegExp(pattern).hasMatch(val)) {
      return errorMessage;
    }

    return null;
  }

  String? rangeValidator(num? val, num min, num max) {
    if (val == null) return null;

    if (val < min || val > max) {
      return "Value must be between $min and $max!";
    }

    return null;
  }

  String? dateValidator(DateTime? date, {DateTime? min, DateTime? max}) {
    if (date == null) return null;

    if (min != null && date.isBefore(min)) {
      return "Date must be after ${min.toIso8601String()}!";
    }
    if (max != null && date.isAfter(max)) {
      return "Date must be before ${max.toIso8601String()}!";
    }
    return null;
  }

  String? lengthValidator(String? val, int length) {
    if (val == null || val.isEmpty) {
      return null;
    }

    if (val.length != length) {
      return "Field must be exactly $length characters!";
    }

    return null;
  }

  String? multiCheck(String? val, List<String? Function(String?)> validators) {
    for (var validator in validators) {
      final result = validator(val);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  String? mobileNumber(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Please enter your mobile number!';
    }

    // final pattern = r'^\+?[1-9]\d{10,15}$';
    // if (!RegExp(pattern).hasMatch(val.trim())) {
    //   return 'Please enter a valid international phone number';
    // }

    if (!RegExp(r'^\d{10,15}$').hasMatch(val)) {
      return 'Please enter a valid mobile number!';
    }

    return null;
  }

  String? match(String? val, String secondValue, String errorMessage) {
    if (val == null || val.trim().isEmpty) {
      return 'Please enter the password!';
    }

    // final pattern = r'^\+?[1-9]\d{10,15}$';
    // if (!RegExp(pattern).hasMatch(val.trim())) {
    //   return 'Please enter a valid international phone number';
    // }

    if (val != secondValue) {
      return errorMessage;
    }

    return null;
  }
}
