import 'package:favorito_user/component/Following.dart';
import 'package:favorito_user/component/PinCodeVerificationScreen.dart';
import 'package:favorito_user/ui/OnlineMenu/Order/OrderHome.dart';
import 'package:favorito_user/ui/appointment/AppBookDetail.dart';
import 'package:favorito_user/ui/appointment/BookAppointment.dart';
import 'package:favorito_user/ui/Booking/BookTable.dart';
import 'package:favorito_user/ui/Booking/BookingOrAppointmentList.dart';
import 'package:favorito_user/ui/BottomNavigationPage.dart';
import 'package:favorito_user/ui/ForgetPassword/forgetPassword.dart';
import 'package:favorito_user/ui/Login/ChangePass.dart';
import 'package:favorito_user/ui/Login/EmialUpdate.dart';
import 'package:favorito_user/ui/Login/Login.dart';
import 'package:favorito_user/ui/Login/LoginDetail.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHome.dart';
import 'package:favorito_user/ui/Signup/Signup.dart';
import 'package:favorito_user/ui/business/BusinessProfile.dart';
import 'package:favorito_user/ui/business/tabs/JobDetail.dart';
import 'package:favorito_user/ui/business/tabs/Review/Review.dart';
import 'package:favorito_user/ui/business/waitlist/JoinWaitList.dart';
import 'package:favorito_user/ui/business/waitlist/waitlist.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/ui/splash/Splash.dart';
import 'package:favorito_user/ui/user/Following.dart';
import 'package:favorito_user/ui/user/PersonalInfo/AddAdress.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfo.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddress.dart';
import 'package:favorito_user/ui/user/ProfileDetail.dart';
import 'package:favorito_user/ui/user/profile.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => PayHome());
        // return MaterialPageRoute(builder: (_) => ReviewTab());
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());

      case '/signUp':
        return MaterialPageRoute(builder: (_) => Signup());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());

      case '/profileMaster':
        return MaterialPageRoute(builder: (_) => ProfileMaster());

      case '/businessProfile':
        return MaterialPageRoute(builder: (_) => BusinessProfile());

      case '/following':
        return MaterialPageRoute(builder: (_) => Following());

      case '/followingUser':
        return MaterialPageRoute(builder: (_) => FollowingUser());

      case '/waitlist':
        return MaterialPageRoute(builder: (_) => Waitlist());

      case '/bookingOrAppointmentList':
        return MaterialPageRoute(builder: (_) => BookingOrAppointmentParent());

      case '/searchResult':
        return MaterialPageRoute(builder: (_) => SearchResult(data: args));

      case '/joinWaitList':
        return MaterialPageRoute(builder: (_) => JoinWaitList());

      case '/bookTable':
        return MaterialPageRoute(builder: (_) => BookTable());

      case '/personalInfo':
        return MaterialPageRoute(builder: (_) => PersonalInfo());
      case '/menuHome':
        return MaterialPageRoute(builder: (_) => MenuHome());
      case '/forgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case '/userAddress':
        return MaterialPageRoute(builder: (_) => UserAddress());
      case '/addAddress':
        return MaterialPageRoute(builder: (_) => AddAddress());
      case '/pinCodeVerificationScreen':
        return MaterialPageRoute(builder: (_) => PinCodeVerificationScreen());
      case '/loginDetail':
        return MaterialPageRoute(builder: (_) => LoginDetail());
      case '/updateEmail':
        return MaterialPageRoute(builder: (_) => UpdateEmail());
      case '/changePass':
        return MaterialPageRoute(builder: (_) => ChangePass());
      case '/bookAppointment':
        return MaterialPageRoute(builder: (_) => BookAppointment());
      case '/appBookDetail':
        return MaterialPageRoute(builder: (_) => AppBookDetail());
      case '/orderHome':
        return MaterialPageRoute(builder: (_) => OrderHome());
      case '/review':
        return MaterialPageRoute(builder: (_) => Review());
      case '/JobDetail':
        return MaterialPageRoute(builder: (_) => JobDetail());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error',
              style: TextStyle(
                  fontFamily: 'Gilroy-Reguler',
                  fontWeight: FontWeight.w600,
                  letterSpacing: .4,
                  fontSize: 20)),
        ),
        body: Center(
          child: Text('Something Went Wrong'),
        ),
      );
    });
  }
}
