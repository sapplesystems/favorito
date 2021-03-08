import 'package:favorito_user/component/Following.dart';
import 'package:favorito_user/ui/Booking/BookTable.dart';
import 'package:favorito_user/ui/Booking/BookingOrAppointmentList.dart';
import 'package:favorito_user/ui/BottomNavigationPage.dart';
import 'package:favorito_user/ui/ForgetPassword/forgetPassword.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHome.dart';
import 'package:favorito_user/ui/Signup/Signup.dart';
import 'package:favorito_user/ui/profile/business/BusinessProfile.dart';
import 'package:favorito_user/ui/profile/business/waitlist/JoinWaitList.dart';
import 'package:favorito_user/ui/profile/business/waitlist/waitlist.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/PersonalInfo.dart';
import 'package:favorito_user/ui/profile/user/ProfileDetail.dart';
import 'package:favorito_user/ui/profile/user/profile.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/ui/splash/Splash.dart';
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
        return MaterialPageRoute(
            builder: (_) => BusinessProfile(businessId: args));

      case '/following':
        return MaterialPageRoute(builder: (_) => Following());

      case '/waitlist':
        return MaterialPageRoute(builder: (_) => Waitlist(data: args));

      case '/bookingOrAppointmentList':
        return MaterialPageRoute(builder: (_) => BookingOrAppointmentParent());

      case '/searchResult':
        return MaterialPageRoute(builder: (_) => SearchResult(data: args));

      case '/joinWaitList':
        return MaterialPageRoute(builder: (_) => JoinWaitList(data: args));

      case '/bookTable':
        return MaterialPageRoute(builder: (_) => BookTable());

      case '/personalInfo':
        return MaterialPageRoute(builder: (_) => PersonalInfo());
      case '/menuHome':
        return MaterialPageRoute(builder: (_) => MenuHome());
      case '/forgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPassword());
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
