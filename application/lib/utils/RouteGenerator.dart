import 'package:Favorito/component/NetworkImages.dart';
import 'package:Favorito/ui/ResetPass/ResetPass.dart';
import 'package:Favorito/ui/adSpent/adspent.dart';
import 'package:Favorito/ui/appoinment/AddPerson.dart';
import 'package:Favorito/ui/appoinment/AddRestriction.dart';
import 'package:Favorito/ui/appoinment/AddServices.dart';
import 'package:Favorito/ui/appoinment/ManualAppoinment.dart';
import 'package:Favorito/ui/booking/BookigDateRistriction.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/ui/catalog/NewCatlog.dart';
import 'package:Favorito/ui/claim/buisnessClaim.dart';
import 'package:Favorito/ui/forgetPass/ForgetPass.dart';
import 'package:Favorito/ui/jobs/CreateJob.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/notification/Notifications.dart';
import 'package:Favorito/ui/signup/signup_a.dart';
import 'package:Favorito/ui/tour/Splash.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => BusinessClaim());
        return MaterialPageRoute(builder: (_) => Splash());

      case '/signUpA':
        return MaterialPageRoute(builder: (_) => Signup_a());

      case '/createJob':
        return MaterialPageRoute(builder: (_) => CreateJob());

      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      case '/bottomNavigation':
        return MaterialPageRoute(builder: (_) => bottomNavigation());

      case '/bottomNavigationBar':
        return MaterialPageRoute(builder: (_) => BottomNavigationBar());

      case '/forgetPass':
        return MaterialPageRoute(builder: (_) => ForgetPass());

      case '/notifications':
        return MaterialPageRoute(builder: (_) => Notifications());

      case '/adSpent':
        return MaterialPageRoute(builder: (_) => adSpent());

      case '/addPerson':
        return MaterialPageRoute(builder: (_) => AddPerson());

      case '/addServices':
        return MaterialPageRoute(builder: (_) => AddServices());

      case '/AddRestriction':
        return MaterialPageRoute(builder: (_) => AddRestriction());

      case '/manualAppoinment':
        return MaterialPageRoute(builder: (_) => ManualAppoinment());

      case '/ResetPass':
        return MaterialPageRoute(builder: (_) => ResetPass());

      case '/networkImages':
        return MaterialPageRoute(
            builder: (_) => NetworkImages(
                  url:
                      'https://wonderfulengineering.com/wp-content/uploads/2016/01/nature-wallpapers-38-610x381.jpg',
                ));

      case '/bookigDateRistriction':
        return MaterialPageRoute(builder: (_) => BookigDateRistriction());

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
