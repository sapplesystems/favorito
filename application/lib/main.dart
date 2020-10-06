import 'package:Favorito/component/workingDateTime.dart';
import 'package:Favorito/ui/appoinment/appoinmentSetting.dart';
import 'package:Favorito/ui/booking/Bookings.dart';
import 'package:Favorito/ui/login/login.dart';
import 'package:Favorito/ui/setting/businessProfile.dart';
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
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favorito',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: Colors.red, //change your color here
        ),
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login()
      // Bookings()
      // BusinessProfile()
      // WaitListSetting()
      // ManualWaitList()
      // WorkingDateTime()
      // appoinmentSetting()
      );
}
