class service {
  //base
  static final baseApi = 'http://demos.sappleserve.com:3000/api/';
  static final baseUser = baseApi + 'user';
  static final baseBusiness = baseApi + 'business';
  static final baseUserBusiness = baseUser + 'business';
  static final baseUserProfile = baseUser + '-profile/';
  static final baseBusinessDashboard = baseBusiness + '-dashboard/';

//function
  static final register = baseUser + 'register';
  static final login = baseUser + 'login';
  static final businessCarousel = baseUserProfile + 'business-carousel';
  static final getAddress = baseApi + 'user-address/get-address';
  static final getUserImage = baseApi + 'user-profile/user-profile-photo';
  static final search = baseApi + 'user-business/search-by-name';
  static final hotAndNewBusiness = baseBusinessDashboard + 'get-new-business';
}
