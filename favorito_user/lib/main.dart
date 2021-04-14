import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BaseProvider.dart';
import 'package:favorito_user/Providers/BasketControllers.dart';
import 'package:favorito_user/ui/Booking/AppBookProvider.dart';
import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/Providers/OptController.dart';
import 'package:favorito_user/ui/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:favorito_user/ui/Login/LoginController.dart';
import 'package:favorito_user/ui/Route/route_generator.dart';
import 'package:favorito_user/ui/Signup/SignupProvider.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/user/PersonalInfo/UserAddressProvider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'utils/MyColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MultiProvider(
      providers: [
        // Provider(create: (context) => BaseProvider()),
        Provider(create: (context) => BaseProvider()),
        ChangeNotifierProvider(create: (context) => MenuHomeProvider()),
        ChangeNotifierProvider(create: (context) => BasketControllers()),
        ChangeNotifierProvider(create: (context) => OptController()),
        ChangeNotifierProvider(create: (context) => AppBookProvider()),
        ChangeNotifierProvider(create: (context) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => PersonalInfoProvider()),
        ChangeNotifierProvider(create: (context) => UserAddressProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => BusinessProfileProvider()),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => NeumorphicApp(
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute);
}
