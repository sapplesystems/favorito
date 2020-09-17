import 'package:application/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  //initializeReflectable();
  runApp(MyApp());
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
          color: Colors.black, //change your color here
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login());
}
