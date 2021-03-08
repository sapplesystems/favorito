import 'package:favorito_user/utils/Regexer.dart';

class Validator {
  String validateUserName(String _val) {
    if (_val?.isEmpty)
      return 'Field is required..'; //replace with fieldIsRequired
    else if (!emailAndMobileRegex.hasMatch(_val)) {
      return 'Invalid username'; //replace with invalidUsername
    } else
      return null;
  }

  String validateOtp(String _val) {
    if (_val?.isEmpty)
      return 'Please enter Otp!';
    else if (_val.length < 5)
      return 'Incomplete Otp!';
    else
      return null;
  }

  String validatePassword(String _val) {
    if (_val?.isEmpty)
      return 'Field is required..';
    else if (!passwordRegex.hasMatch(_val ?? ''))
      return 'Minimum eight characters, atleast one letter and one number one special character';
    else
      return null;
  }

//cpmpare two password
  String compareTwoPassword(String _pass1, String _pass2) {
    if (_pass1?.isEmpty)
      return null;
    else if (_pass2?.isEmpty)
      return 'Field is required..';
    else if (_pass1 != _pass2)
      return '$_pass1 $_pass2';
    else
      return null;
  }

//this will validate full name like rohit shukla
  String validateFullName(String _val) =>
      _val.isEmpty ? 'Field is required..' : null;

  String validateMobile(String _val) {
    if (_val?.isEmpty)
      return 'Field is required..';
    else if (!mobileRegex.hasMatch(_val ?? ''))
      return 'Invalid contact number';
    else
      return null;
  }

  String validateEmail(String _val) {
    print(_val);
    if (_val?.isEmpty)
      return 'Field is required..';
    else if (!emailRegex.hasMatch(_val ?? ''))
      return 'Invalid email address';
    else
      return null;
  }

  String validatePin(String _val) {
    if (_val?.isEmpty)
      return 'Field is required..';
    else if (!pincodeRegex.hasMatch(_val))
      return 'Invalid pincode';
    else
      return null;
  }

  String validateId(String _val) {
    if (_val?.isEmpty)
      return 'Field is required..';
    else if (_val.trim().substring(0, 1) != '@')
      return 'Id should start from \'@';
    // else
    //   return null;
  }
}
