import 'package:Favorito/ui/adSpent/adspent.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/ui/forgetPass/ForgetPass.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/signup/signup_a.dart';
import 'package:Favorito/ui/tour/Splash.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Splash());

      case '/signUpA':
        return MaterialPageRoute(builder: (_) => Signup_a());

      // case '/navbar':
      //   return MaterialPageRoute(builder: (_) => BottomNavBar());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/bottomNavigation':
        return MaterialPageRoute(builder: (_) => bottomNavigation());

      case '/bottomNavigationBar':
        return MaterialPageRoute(builder: (_) => BottomNavigationBar());

      case '/forgetPass':
        return MaterialPageRoute(builder: (_) => ForgetPass());

      // case '/businessProfile':
      //   return MaterialPageRoute(
      //       builder: (_) => BusinessProfile(businessId: args));

      case '/adSpent':
        return MaterialPageRoute(builder: (_) => adSpent());

      // case '/waitlist':
      //   return MaterialPageRoute(builder: (_) => Waitlist(data: args));

      // case '/bookingOrAppointmentList':
      //   return MaterialPageRoute(builder: (_) => BookingOrAppointmentParent());

      // case '/searchResult':
      //   return MaterialPageRoute(builder: (_) => SearchResult(data: args));

      // case '/joinWaitList':
      //   return MaterialPageRoute(builder: (_) => JoinWaitList(data: args));

      // case '/bookTable':
      //   return MaterialPageRoute(builder: (_) => BookTable());

      // case '/personalInfo':
      //   return MaterialPageRoute(builder: (_) => PersonalInfo());
      // case '/menuHome':
      //   return MaterialPageRoute(builder: (_) => MenuHome());
      default:
        return MaterialPageRoute(builder: (_) => Login());
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
