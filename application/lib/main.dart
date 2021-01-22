import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Favorito',
        darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          textTheme: TextTheme(
            title: TextStyle(
                fontSize: 28, color: Colors.black, fontFamily: 'Gilroy-Bold'),
            // subhead: TextStyle(fontSize: 14, color: myGrey),
            body1: TextStyle(fontSize: 16, color: Colors.black),
            body2: TextStyle(fontSize: 18, color: Colors.black),
          ),
          fontFamily: 'Gilroy-Regular',
          primaryColor: myRed,
          accentColor: myRedLight,
          appBarTheme: AppBarTheme(
            color: myBackGround,
            elevation: 0,
          ),
          cardTheme: CardTheme(shape: roundedRectangleBorder, elevation: 2),
          iconTheme: IconThemeData(color: Colors.red),
          scaffoldBackgroundColor: myBackGround,
          bottomAppBarColor: myBackGround,
          bottomAppBarTheme: BottomAppBarTheme(color: myBackGround),
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: bottomNavigation());
  }
}
