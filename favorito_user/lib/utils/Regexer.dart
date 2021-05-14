Pattern _mobilePattern = r'^[6-9]{1}\d{9}$';
Pattern _pincodePattern = r'^[1-9]{1}[0-9]{5}|[1-9]{1}[0-9]{3}\\s[0-9]{3}$';
Pattern _fullnamePattern = r'^[a-zA-Z]+(?:-[a-zA-Z]+)*$';
Pattern _otpPattern = r'^\d{6}$';
Pattern _numberPattern = r'^[0-9]{1,45}$';
// Pattern _emailPattern =
//     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
Pattern _emailAndMobilePattern =
    r'^[6-9]{1}\d{9}|(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
Pattern _passwordPattern =
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';

RegExp mobileRegex = RegExp(_mobilePattern);
RegExp otpRegex = RegExp(_otpPattern);
RegExp onlyNumberRegex = RegExp(_numberPattern);
RegExp emailRegex = RegExp(_emailAndMobilePattern);
RegExp emailAndMobileRegex = RegExp(_emailAndMobilePattern);
RegExp passwordRegex = RegExp(_passwordPattern);
RegExp fullnameRegex = RegExp(_fullnamePattern);
RegExp pincodeRegex = RegExp(_pincodePattern);
