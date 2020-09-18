class serviceFunction {
  static String baseUrl = 'http://demos.sappleserve.com:3000/api/business-';
  static String funCatList = baseUrl + 'category/list';
  static String funBusyList = baseUrl + 'type/list';
  static String funGetNotifications = baseUrl + 'notification/list';
  static String funBusyRegister = baseUrl + 'user/register';
  static String funGetCreateNotificationDefaultData =
      baseUrl + 'notification/getDefaultData';
  static String funCreateNotification = baseUrl + 'notification/create';
  static String funGetCities = baseUrl + 'notification/cityList';
  static String funValidPincode = baseUrl + 'notification/validPincode';
  static String funGetJobs = baseUrl + 'job/list';
  static String funGetCreteJobDefaultData = baseUrl + 'job/getRequiredData';
}
