import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/ResetPass/ResetPassProvider.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/ui/catalog/CatalogsProvider.dart';
import 'package:Favorito/ui/contactPerson/ContactPersonProvider.dart';
import 'package:Favorito/ui/dashboard/dashboardProvider.dart';
import 'package:Favorito/ui/forgetPass/ForgetPassProvider.dart';
import 'package:Favorito/ui/jobs/JobProvider.dart';
import 'package:Favorito/ui/notification/NotificationProvider.dart';
import 'package:Favorito/ui/offer/offersProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:Favorito/ui/waitlist/WaitlistProvider.dart';
import 'package:Favorito/utils/RouteGenerator.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: ".env");
  // print('size:${FlutterConfig.get('image_max_length')}');
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
      ChangeNotifierProvider(create: (context) => ResetPassProvider()),
      ChangeNotifierProvider(create: (context) => WaitlistProvider()),
      ChangeNotifierProvider(create: (context) => CatalogsProvider()),
      ChangeNotifierProvider(create: (context) => OffersProvider()),
      ChangeNotifierProvider(create: (context) => JobProvider()),
      ChangeNotifierProvider(create: (context) => NotificationsProvider()),
      ChangeNotifierProvider(create: (context) => UtilProvider()),
      ChangeNotifierProvider(create: (context) => BookingProvider()),
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
        fontFamily: 'Gilroy-Regular',
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 28, color: Colors.black, fontFamily: 'Gilroy-Bold'),
          body1: TextStyle(fontSize: 16, color: Colors.black),
          body2: TextStyle(fontSize: 18, color: Colors.black)
        ),
        primaryColor: myRed,
        accentColor: myRedLight,
        appBarTheme: AppBarTheme(
          color: myBackGround,
          elevation: 0
        ),
        cardTheme: CardTheme(shape: roundedRectangleBorder, elevation: 2),
        iconTheme: IconThemeData(color: Colors.red),
        scaffoldBackgroundColor: myBackGround,
        bottomAppBarColor: myBackGround,
        bottomAppBarTheme: BottomAppBarTheme(color: myBackGround),
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
