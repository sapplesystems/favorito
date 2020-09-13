import 'package:flutter/material.dart';

class txtfieldboundry extends StatefulWidget {
  String title;
  bool security;
  txtfieldboundry({this.title, this.security});
  @override
  _txtfieldboundryState createState() => _txtfieldboundryState();
}

class _txtfieldboundryState extends State<txtfieldboundry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        obscureText: widget.security,
        decoration: new InputDecoration(
          labelText: widget.title,
          fillColor: Colors.transparent,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(12.0),
            borderSide: new BorderSide(),
          ),
          // fillColor: Colors.green
        ),
        validator: (val) {
          if (val.length == 0) {
            return "${widget.title} cannot be empty";
          } else
            return null;
        },
        keyboardType: TextInputType.emailAddress,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
