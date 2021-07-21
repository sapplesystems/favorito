import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/ui/Booking/AppBookProvider.dart';
import 'package:favorito_user/ui/OnlineMenu/MenuHomeProvider.dart';
import 'package:favorito_user/Providers/OptController.dart';
import 'package:favorito_user/ui/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/ui/OnlineMenu/Order/OrderProvider.dart';
import 'package:favorito_user/ui/Route/route_generator.dart';
import 'package:favorito_user/ui/Signup/SignupProvider.dart';
import 'package:favorito_user/ui/appointment/appointmentProvider.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/business/tabs/Review/ReviewProvider.dart';
import 'package:favorito_user/ui/chat/ChatProvider.dart';
import 'package:favorito_user/ui/notification/NofificationProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/ui/user/ProfileProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'utils/MyColors.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(
      providers: [
        // Provider(create: (context) => BaseProvider()),
        ChangeNotifierProvider(create: (context) => BaseProvider()),
        ChangeNotifierProvider(create: (context) => MenuHomeProvider()),
        ChangeNotifierProvider(create: (context) => OptController()),
        ChangeNotifierProvider(create: (context) => AppBookProvider()),
        ChangeNotifierProvider(create: (context) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => PersonalInfoProvider()),
        ChangeNotifierProvider(create: (context) => UserAddressProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BusinessProfileProvider()),
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvicer()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider())
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) => NeumorphicApp(
      debugShowCheckedModeBanner: kReleaseMode ? false : true,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      materialTheme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Color(0xffF4F6FC),
          canvasColor: myGreyDark,
          backgroundColor: myGrey,
          hintColor: myGrey,
          primaryColor: Colors.black,
          primaryIconTheme: IconThemeData(color: Colors.black87),
          primaryTextTheme: TextTheme(
            headline1:
                TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Colors.black),
            headline2:
                TextStyle(fontFamily: 'Gilroy-Heavy', color: Colors.black),
            headline3:
                TextStyle(fontFamily: 'Gilroy-Bold', color: Colors.black),
            headline4:
                TextStyle(fontFamily: 'Gilroy-Medium', color: Colors.black),
            headline5:
                TextStyle(fontFamily: 'Gilroy-Regular', color: Colors.black),
            headline6:
                TextStyle(fontFamily: 'Gilroy-Light', color: Colors.black),
          ),
          appBarTheme: AppBarTheme(
              shadowColor: myRed, foregroundColor: myRed, color: myGreyDark),
          textTheme: TextTheme(
            headline1:
                TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Colors.black),
            headline2:
                TextStyle(fontFamily: 'Gilroy-Heavy', color: Colors.black),
            headline3:
                TextStyle(fontFamily: 'Gilroy-Bold', color: Colors.black),
            headline4:
                TextStyle(fontFamily: 'Gilroy-Medium', color: Colors.black),
            headline5:
                TextStyle(fontFamily: 'Gilroy-Regular', color: Colors.black),
            headline6:
                TextStyle(fontFamily: 'Gilroy-Light', color: Colors.black),
          )), //Gilroy-Regular
      theme: NeumorphicThemeData(
          baseColor: myGreyLight,
          defaultTextColor: myRed,
          accentColor: myRed,
          variantColor: Colors.black38,
          depth: 8,
          textTheme: TextTheme(
            headline1:
                TextStyle(fontFamily: ' Gilroy-ExtraBold', color: Colors.black),
            headline2:
                TextStyle(fontFamily: ' Gilroy-Heavy', color: Colors.black),
            headline3:
                TextStyle(fontFamily: ' Gilroy-Bold', color: Colors.black),
            headline4:
                TextStyle(fontFamily: ' Gilroy-Medium', color: Colors.black),
            headline5:
                TextStyle(fontFamily: ' Gilroy-Regular', color: Colors.black),
            headline6:
                TextStyle(fontFamily: ' Gilroy-Light', color: Colors.black),
          ),
          intensity: 0.65),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute);
}
