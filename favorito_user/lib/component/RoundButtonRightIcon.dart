import 'package:flutter/material.dart';

class RoundButtonRightIcon extends StatefulWidget {
  String title;
  Color clr;
  Color borderColor;
  IconData icon;
  Function function;
  RoundButtonRightIcon(
      {this.title, this.clr, this.icon, this.borderColor, this.function});
  @override
  _RoundButtonRightIconState createState() => _RoundButtonRightIconState();
}

class _RoundButtonRightIconState extends State<RoundButtonRightIcon> {
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
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.borderColor,
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
              Icon(widget.icon, color: widget.clr),
            ],
          ),
        ),
      ),
    );
  }
}
