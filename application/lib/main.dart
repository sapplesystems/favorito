import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/ui/signup/signup_a.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // SizeManager sm;
  @override
  Widget build(BuildContext context) {
    // sm = SizeManager(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Favorito',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          textTheme: TextTheme(
            title: TextStyle(fontSize: 14, color: Colors.black),
            subhead: TextStyle(fontSize: 12, color: myGrey),
            body1: TextStyle(fontSize: 12, color: Colors.black),
            body2: TextStyle(fontSize: 20, color: Colors.black),
          ),
          fontFamily: 'Gilroy-Regular',
          backgroundColor: myBackGround,
          iconTheme: IconThemeData(color: Colors.red),
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: bottomNavigation());
  }
}
