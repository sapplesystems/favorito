import 'package:favorito_user/component/Following.dart';
import 'package:favorito_user/component/PinCodeVerificationScreen.dart';
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
import 'package:favorito_user/ui/business/waitlist/JoinWaitList.dart';
import 'package:favorito_user/ui/business/waitlist/waitlist.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/ui/splash/Splash.dart';
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
        return MaterialPageRoute(builder: (_) => Splash());

      case '/signUp':
        return MaterialPageRoute(builder: (_) => Signup());

      case '/navbar':
        return MaterialPageRoute(builder: (_) => BottomNavBar());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());

      case '/profileDetail':
        return MaterialPageRoute(builder: (_) => ProfileDetail());

      case '/businessProfile':
        return MaterialPageRoute(builder: (_) => BusinessProfile());

      case '/following':
        return MaterialPageRoute(builder: (_) => Following());

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
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Something Went Wrong'),
        ),
      );
    });
  }
}
