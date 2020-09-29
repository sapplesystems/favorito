import 'package:flutter/material.dart';
import 'package:Favorito/utils/myColors.dart';

class toggleTextButton extends StatelessWidget {
  String hint, label;
  Function tapper;
  toggleTextButton({this.hint, this.label, this.tapper});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: tapper,
        child: Container(
          height: 57,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(
            left: 22,
            right: 29,
            top: 19,
            bottom: 18,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Complete your profile ",
                style: TextStyle(
                  color: Color(0xff9996a3),
                  fontSize: 16,
                  fontFamily: "Gilroy-Medium",
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.32,
                ),
              ),
              SizedBox(width: 60.50),
              Container(
                width: 54,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: myRed,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Fill",
                    style: TextStyle(
                      color: myRed,
                      fontSize: 12,
                      fontFamily: "Gilroy-Medium",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
