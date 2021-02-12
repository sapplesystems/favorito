Pattern _mobilePattern = r'^[6-9]{1}\d{9}$';
RegExp mobileRegex = RegExp(_mobilePattern);

Pattern _otpPattern = r'^\d{6}$';
RegExp otpRegex = RegExp(_otpPattern);

Pattern _numberPattern = r'^[0-9]{1,45}$';
RegExp onlyNumberRegex = RegExp(_numberPattern);

Pattern _emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp emailRegex = RegExp(_emailPattern);

Pattern _emailAndMobilePattern =
    r'^[6-9]{1}\d{9}|(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp emailAndMobileRegex = RegExp(_emailAndMobilePattern);
