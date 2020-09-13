import 'package:application/ui/tour/Tour_A.dart';
import 'package:application/ui/signup/signup_a.dart';
import 'package:application/ui/notification/Notifications.dart';
import 'package:flutter/material.dart';

void main() {
  //initializeReflectable();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Favorito',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Notifications(),
      );
}
