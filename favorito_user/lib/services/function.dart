class service {
  //base
  static final base = 'http://demos.sappleserve.com:3000/api/';

//base+business and base+user
  static final baseBusiness = base + 'business-';
  static final baseUser = base + 'user-';
  static final baseUser2 = base + 'user/';
  static final baseBusiness2 = base + 'business/';

  //User+switch

  static final baseUserBusiness = baseUser + 'business-';
  static final baseUserProfile = baseUser + 'profile/';
  static final baseUserWaitlist = baseUser + 'waitlist/';
  static final baseUserBooking = baseUser + 'booking/';
  static final baseUserAppointment = baseUser + 'appointment/';
  static final baseBusinessDashboard = baseBusiness + 'dashboard/';
  static final baseUserOrder = baseUser + 'order/';

//function
  static final register = baseUser2 + 'register';
  static final login = baseUser2 + 'login';
  static final businessCarousel = baseUserProfile + 'business-carousel';
  static final getAddress = base + 'user-address/get-address';
  static final getUserImage = base + 'user-profile/user-profile-photo';
  static final search = base + 'user-business/search-by-name';
  static final hotAndNewBusiness = baseBusinessDashboard + 'get-new-business';
  static final trendingBusiness = baseBusinessDashboard + 'get-trending-nearby';
  static final topRatedBusiness = baseBusinessDashboard + 'get-top-rated';

  static final UserBusinessMenu = baseUserBusiness + 'menu/';
  static final mostPopulerBusiness = baseBusinessDashboard + 'get-most-popular';
  static final foodBusiness = baseBusinessDashboard + 'get-business-by-food';
  static final jobBusiness = baseBusinessDashboard + 'get-business-by-job';
  static final appointmentBusiness =
      baseBusinessDashboard + 'get-business-by-appintment';
  static final freelanceBusiness =
      baseBusinessDashboard + 'get-business-by-freelancer';
  static final doctorBusiness =
      baseBusinessDashboard + 'get-business-by-doctor';
  static final bookTableBusiness =
      baseBusinessDashboard + 'get-business-by-book-table';

  static final baseUserProfileOverview = baseUserProfile + 'business-overview';
  static final baseUserProfileDetail = baseUserProfile + 'business-detail';
  static final baseUserProfileBusinessCatalogList =
      baseUserProfile + 'business-catalog-list';

  static final joblist = base + 'job/list';

  //waitlist
  static final baseUserWaitlistVerbose = baseUserWaitlist + 'waitlist-verbose';
  static final baseUserWaitlistSet = baseUserWaitlist + 'set-waitlist';
  static final baseUserWaitlistGet = baseUserWaitlist + 'get-waitlist';
  static final baseUserWaitlistCancel = baseUserWaitlist + 'cancel-waitlist';

  //relation
  static final businessRelationGet = baseUserProfile + 'user-business-relation';

  //userDetail
  static final userdetail = baseUserProfile + 'user-detail';

  //booking
  static final baseUserBookingList = baseUserBooking + 'get-book-table';

  //appoinment
  static final baseUserAppointmentList =
      baseUserAppointment + 'get-booking-appointment';

  //appoinment
  static final menuTabGet = UserBusinessMenu + 'get-category';
  static final menuTabItemGet =
      UserBusinessMenu + 'get-category-item'; //this is based on previous

  //Order
  static final userOrderCreate =
      baseUserOrder + 'create-order'; //this is used to create a new order

}
