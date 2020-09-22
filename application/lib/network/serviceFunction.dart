class serviceFunction {
  static String baseUrl1 = 'http://demos.sappleserve.com:3000/api/business-';
  static String baseUrl2 = 'http://demos.sappleserve.com:3000/api/';
  static String funCatList = baseUrl1 + 'category/list';
  static String funBusyList = baseUrl1 + 'type/list';
  static String funGetNotifications = baseUrl2 + 'notification/list';
  static String funBusyRegister = baseUrl1 + 'user/register';
  static String funGetCreateNotificationDefaultData =
      baseUrl2 + 'notification/dd-verbose';
  static String funCreateNotification = baseUrl2 + 'notification/add';
  static String funGetCities = baseUrl2 + 'state-city/city-list';
  static String funValidPincode = baseUrl2 + 'notification/verify-pincode';
  static String funGetJobs = baseUrl2 + 'job/list';
  static String funGetCreateJobDefaultData = baseUrl2 + 'job/getRequiredData';
  static String funLogin = baseUrl1 + 'user/login';
  static String funDash = baseUrl1 + 'dashboard/detail';
  static String funGetCreateOfferDefaultData = baseUrl2 + 'offer/dd-verbose';
  static String funCreateOffer = baseUrl2 + 'offer/create';
  static String funCreateJob = baseUrl2 + 'job/create';
}
