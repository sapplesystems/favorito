import 'package:favorito_user/component/Following.dart';
import 'package:favorito_user/ui/BottomNavigationPage.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/ui/Signup.dart';
import 'package:favorito_user/ui/profile/business/BusinessProfile.dart';
import 'package:favorito_user/ui/profile/user/ProfileDetail.dart';
import 'package:favorito_user/ui/profile/user/profile.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar());

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
            builder: (_) => BusinessProfile(businessId: args)
            // builder: (_) => Tabber(),
            );

      case '/following':
        return MaterialPageRoute(builder: (_) => Following());

        return _errorRoute();
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
          child: Text('ERROR'),
        ),
      );
    });
  }
}
