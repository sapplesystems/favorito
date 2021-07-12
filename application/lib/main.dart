import 'package:Favorito/Provider/SignUpProvider.dart';
import 'package:Favorito/ui/Chat/ChatProvider.dart';
import 'package:Favorito/ui/ResetPass/ResetPassProvider.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/ui/bottomNavigation/bottomNavigationProvider.dart';
import 'package:Favorito/ui/catalog/CatalogsProvider.dart';
import 'package:Favorito/ui/claim/ClaimProvider.dart';
import 'package:Favorito/ui/contactPerson/ContactPersonProvider.dart';
import 'package:Favorito/ui/dashboard/dashboardProvider.dart';
import 'package:Favorito/ui/forgetPass/ForgetPassProvider.dart';
import 'package:Favorito/ui/jobs/JobProvider.dart';
import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:Favorito/ui/notification/NotificationProvider.dart';
import 'package:Favorito/ui/offer/offersProvider.dart';
import 'package:Favorito/ui/order/OrderProvider.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/ui/setting/businessInfo/businessInfoProvider.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';
import 'package:Favorito/ui/waitlist/WaitlistProvider.dart';
import 'package:Favorito/utils/RouteGenerator.dart';
import 'package:Favorito/utils/UtilProvider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './utils/MyTheme.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DotEnv.load(fileName: ".env");
  // print('size:${FlutterConfig.get('image_max_length')}');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SignUpProvider()),
      ChangeNotifierProvider(create: (context) => ContactPersonProvider()),
      // ChangeNotifierProvider(create: (context) => BusinessHoursProvider()),
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
      ChangeNotifierProvider(create: (context) => MenuProvider()),
      ChangeNotifierProvider(create: (context) => AppoinmentProvider()),
      ChangeNotifierProvider(create: (context) => ChatProvier()),
      ChangeNotifierProvider(create: (context) => ClaimProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
      ChangeNotifierProvider(create: (context) => businessInfoProvider()),
      ChangeNotifierProvider(create: (context) => bottomNavigationProvider()),
    ], child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: kReleaseMode ? false : true,
      title: 'Favorito',
      darkTheme: MyTheme().themeDataDark,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: MyTheme().themeDataLight,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
