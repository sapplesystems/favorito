import 'package:Favorito/ui/bottomNavigation/bottomNavigation.dart';
import 'package:Favorito/utils/Prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SizeManager sm;

  @override
  void initState() {
    super.initState();
    decide();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icon/f.svg',
              alignment: Alignment.center,
              height: sm.h(20),
            ),
            Text(
              "FAVORITO",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w500,
                letterSpacing: 1.25,
              ),
            )
          ],
        ),
      ),
    );
  }

  void decide() async {
    var token = await Prefs.token;
    if (token != null && token != "") {
      print("Token:$token");
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => bottomNavigation()));
      });
    } else {
      Navigator.pop(context);
      Navigator.of(context).pushNamed('/login');
    }
  }
}
