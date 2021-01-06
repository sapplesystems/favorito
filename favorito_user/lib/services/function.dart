class service {
  //base
  static final base = 'http://demos.sappleserve.com:3000/api/';

//base+business and base+user
  static final baseBusiness = base + 'business-';
  static final baseUser = base + 'user-';
  static final baseUser2 = base + 'user/';
  static final baseBusiness2 = base + 'business/';

  //User+switch

  static final baseUserBusiness = baseUser + 'business';
  static final baseUserProfile = baseUser + 'profile/';
  static final baseUserWaitlist = baseUser + 'waitlist/';
  static final baseUserBooking = baseUser + 'booking/';
  static final baseBusinessDashboard = baseBusiness + 'dashboard/';

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

  static final mostPopulerBusiness = baseBusinessDashboard + 'get-most-popular';

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

  //booking
  static final baseUserBookingList = baseUserBooking + 'get-book-table';
}
