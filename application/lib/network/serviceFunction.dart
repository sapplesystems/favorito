import 'package:Favorito/network/BaseUrl.dart';
import 'package:Favorito/network/ServeControl.dart';

class serviceFunction {
  static String adSpent = "ad-spent-campaign/";
  static String funCatList = baseUrl1 + 'category/list';
  static String funSubCatList = baseUrl1 + 'sub-category/list';
  static String funBusyList = baseUrl1 + 'type/list';
  static String funBusyRegister = baseUrl1 + 'user/register';
  static String funGetCities = baseUrl2 + 'state-city/city-list';
  static String funGetStates = baseUrl2 + 'state-city/state-list';
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

  static String funGetWaitlist = baseUrl1 + 'waitlist/list';
  static String funCreateWaitlist = baseUrl1 + 'waitlist/create';
  static String funWaitlistUpdateStatus = baseUrl1 + 'waitlist/update-status';
  static String funWaitlistSaveSetting = baseUrl1 + 'waitlist/save-setting';
  static String funWaitlistSetting = baseUrl1 + 'waitlist/setting';
  static String funWaitlistDelete = baseUrl1 + 'waitlist/delete';
  static String funSearchBranches = baseUrl2 + 'business-user/search-branch';
  static String funGetBusinessProfileData = baseUrl2 + 'business-user/profile';
  static String funGetOfferData = funOffer + 'list';
  static String funEditOffer = funOffer + 'edit';
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
  static String funCreateCampain = baseUrl1 + 'ad-spent-campaign/create';
  static String funCreateCampainEdit = baseUrl1 + 'ad-spent-campaign/edit';
  static String funOrderList = baseUrl1 + 'order/list';
  static String funCatalogAddPhoto = baseUrl2 + 'catalog/add-photo';
  static String funCatalogEdit = baseUrl2 + 'catalog/edit';

  static String funManualBooking = funBooking + 'create';
  static String funBookingSetting = funBooking + 'setting';
  static String funBookingSaveSetting = funBooking + 'save-setting';
  static String funBookingList = funBooking + 'list';
  static String funBookingEdit = funBooking + 'edit';

  static String funNotificationsList = funNotification + 'list';
  static String funGetCreateNotificationDefaultData =
      funNotification + 'dd-verbose';
  static String funCreateNotification = funNotification + 'add';
  static String funValidPincode = funNotification + 'verify-pincode';
  static String funNotificationsDetail = funNotification + 'detail';

  //appoinment
  static String funAppoinmentCreate = funAppointment + 'create';
  static String funAppoinmentDetail = funAppointment + 'detail';
  static String funAppoinmentVerbose = funAppointment + 'dd-verbose';
  static String funAppoinmentList = funAppointment + 'list';
  static String funAppoinmentSaveSetting = funAppointment + 'save-setting';
  static String funAppoinmentSetting = funAppointment + 'setting';
  static String funAppoinmentSaveService = funAppointment + 'save-service';
  static String funAppoinmentService = funAppointment + 'appointment-service';
  static String funAppoinmentSavePerson = funAppointment + 'save-person';
  static String funAppoinmentPerson = funAppointment + 'get-all-person';
  static String funAppoinmentRestriction =
      funAppointment + 'get-all-restriction';
  static String funAppoinmentSaveRestriction =
      funAppointment + 'save-restriction';
  static String funAppoinmentEditRestriction =
      funAppointment + 'edit-restriction';
  static String funAppoinmentDeleteRestriction =
      funAppointment + 'delete-restriction';
  static String funAppoinmentPersonOnOff = funAppointment + 'set-person-status';
  static String funAppoinmentServiceOnOff =
      funAppointment + 'set-service-status';

  //checkins
  static String funCheckinslist = funChecklist + 'list';

  //claim

  static String funClaimSendMail = funClaim + 'send-email-verify-link';
  static String funSendOtpSms = funClaim + 'send-otp-sms';
  static String funClaimInfo = funUser + 'get-registered-email-phone';
  static String funClaimVerifyOtp = funClaim + 'verify-otp';
  static String funSendEmailVerifyLink = funClaim + 'send-email-verify-link';
  static String funClaimAdd = funClaim + 'add';

  //Review

  static String funReviewIntro = funReview + 'get-review-detail';

  static String funReviewList = funReview + 'review-list';

  static String funReviewgetReviewReplies = funReview + 'get-review-replies';

  static String funReviewReply = funReview + 'set-review';
}
