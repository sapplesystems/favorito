import 'package:favorito_user/ui/BottomNavigationPage.dart';
import 'package:favorito_user/ui/Login.dart';
import 'package:favorito_user/ui/Signup.dart';
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
