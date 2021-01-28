import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/MenuHomeProvider.dart';
import 'package:favorito_user/ui/Route/route_generator.dart';
import 'package:flutter/material.dart';
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
        onGenerateRoute: RouteGenerator.generateRoute,
      );
}
