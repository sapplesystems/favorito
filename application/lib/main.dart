import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/contactPerson/ContactPersonProvider.dart';
import 'package:Favorito/ui/dashboard/dashboardProvider.dart';
import 'package:Favorito/ui/forgetPass/ForgetPassProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:Favorito/utils/RouteGenerator.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SignUpProvider()),
      ChangeNotifierProvider(create: (context) => ContactPersonProvider()),
      ChangeNotifierProvider(create: (context) => BusinessHoursProvider()),
      ChangeNotifierProvider(create: (context) => SettingProvider()),
      ChangeNotifierProvider(create: (context) => ForgetPassProvider()),
      ChangeNotifierProvider(create: (context) => BusinessProfileProvider()),
      ChangeNotifierProvider(create: (context) => dashboardProvider()),
    ], child: MyApp()));
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
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
