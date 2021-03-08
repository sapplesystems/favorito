import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BookTableProvider.dart';
import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/Providers/OptController.dart';
import 'package:favorito_user/ui/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:favorito_user/ui/Route/route_generator.dart';
import 'package:favorito_user/Providers/BasketControllers.dart';
import 'package:favorito_user/ui/Signup/SignupProvider.dart';
import 'package:favorito_user/ui/profile/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/PersonalInfoProvider.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddress.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import 'utils/MyColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MenuHomeProvider()),
          ChangeNotifierProvider(create: (context) => BasketControllers()),
          ChangeNotifierProvider(create: (context) => OptController()),
          ChangeNotifierProvider(create: (context) => AppBookProvider()),
          ChangeNotifierProvider(create: (context) => ForgetPasswordProvider()),
          ChangeNotifierProvider(create: (context) => SignupProvider()),
          ChangeNotifierProvider(create: (context) => PersonalInfoProvider()),
          ChangeNotifierProvider(create: (context) => UserAddressProvider()),
          ChangeNotifierProvider(
              create: (context) => BusinessProfileProvider()),
          // Provider(create: (context) => MenuHomeProvider()),
        ],
        child: MyApp(),
      ),
    );
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
