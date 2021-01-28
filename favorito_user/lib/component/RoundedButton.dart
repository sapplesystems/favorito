import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {
  Color clr;
  String title;
  Function clicker;
  RoundedButton({this.clr, @required this.title, @required this.clicker});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: clicker,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: clr ?? myRed,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Gilroy-Bold",
                  letterSpacing: 1))),
    );
  }
}
