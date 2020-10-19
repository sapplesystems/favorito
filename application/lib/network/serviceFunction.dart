class serviceFunction {
  static String baseUrl1 = 'http://demos.sappleserve.com:3000/api/business-';
  static String baseUrl2 = 'http://demos.sappleserve.com:3000/api/';
  static String adSpent = "ad-spent-campaign/";
  static String funCatList = baseUrl1 + 'category/list';
  static String funSubCatList = baseUrl1 + 'sub-category/list';
  static String funBusyList = baseUrl1 + 'type/list';
  static String funGetNotifications = baseUrl2 + 'notification/list';
  static String funBusyRegister = baseUrl1 + 'user/register';
  static String funGetCreateNotificationDefaultData =
      baseUrl2 + 'notification/dd-verbose';
  static String funCreateNotification = baseUrl2 + 'notification/add';
  static String funGetCities = baseUrl2 + 'state-city/city-list';
  static String funGetStates = baseUrl2 + 'state-city/state-list';
  static String funValidPincode = baseUrl2 + 'notification/verify-pincode';
  static String funGetJobs = baseUrl2 + 'job/list';
  static String funGetCreateJobDefaultData = baseUrl2 + 'job/dd-verbose';
  static String funLogin = baseUrl1 + 'user/login';
  static String funDash = baseUrl1 + 'dashboard/detail';
  static String funGetCreateOfferDefaultData = baseUrl2 + 'offer/dd-verbose';
  static String funCreateOffer = baseUrl2 + 'offer/create';
  static String funCreateJob = baseUrl2 + 'job/create';
  static String funContactPersonRequiredData =
      baseUrl2 + 'business-user/owner-profile';
  static String funUpdateContactPerson =
      baseUrl2 + 'business-user/update-owner-profile';
  static String funGetCityByPincode = baseUrl2 + 'job/city-from-pincode';
  static String funGetPincodesForCity = baseUrl2 + 'job/city-pincode';
  static String funGetCatalogs = baseUrl2 + 'catalog/list';
  static String funGetWaitlist = baseUrl2 + 'business-waitlist/list';
  static String funCreateManualBooking = baseUrl2 + 'business-booking/create';
  static String funSearchBranches = baseUrl2 + 'business-user/search-branch';
  static String funGetBusinessProfileData = baseUrl2 + 'business-user/profile';
  static String funGetOfferData = baseUrl2 + 'offer/list';
  static String funEditOffer = baseUrl2 + 'offer/edit';
  static String funGetEditJobData = baseUrl2 + 'job/detail';
  static String funEditJob = baseUrl2 + 'job/edit';
  static String funUserProfileUpdate = baseUrl1 + 'user/profile/update';
  static String funProfileUpdatephoto = baseUrl1 + 'user/profile/update-photo';
  static String funUserProfile = baseUrl1 + 'user/profile';
  static String funUserInformation = baseUrl1 + 'user/information';
  static String funUserInformationUpdate = funUserInformation + '/update';
  static String funUserInformationAddPhoto = funUserInformation + '/add-photo';
  static String funUserHighlightAddPhoto = baseUrl1 + 'highlight/add-photo';
  static String funUserHighlightSave = baseUrl1 + 'highlight/save';
  static String funUserHighlightDetails = baseUrl1 + 'highlight/detail';
  static String funAdSpentList = baseUrl1 + adSpent + 'list';
  static String funTagList = baseUrl2 + 'tag/list';
  static String funCampainVerbose = baseUrl1 + 'ad-spent-campaign/dd-verbose';
}
