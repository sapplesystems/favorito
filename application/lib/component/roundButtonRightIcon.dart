import 'package:flutter/material.dart';
import 'package:Favorito/utils/myColors.dart';
class roundButtonRightIcon extends StatefulWidget {
  String title;
  Color clr;
  IconData ico;
  Function function;
  roundButtonRightIcon({this.title, this.clr, this.ico, this.function});
  @override
  _roundButtonRightIconState createState() => _roundButtonRightIconState();
}

class _roundButtonRightIconState extends State<roundButtonRightIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          widget.function();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: myRed,
              width: 1,
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.clr,
                  fontSize: 16,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 23),
              Icon(widget.ico, color: widget.clr),
            ],
          ),
        ),
      ),
    );
  }
}
