import 'package:flutter/material.dart';

class txtfieldboundry extends StatefulWidget {
  String title;
  bool security;
  int maxLines;
  String hintText;
  TextEditingController textController;
  txtfieldboundry(
      {this.title,
      this.security,
      this.maxLines,
      this.hintText,
      this.textController});
  @override
  _txtfieldboundryState createState() => _txtfieldboundryState();
}

class _txtfieldboundryState extends State<txtfieldboundry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.textController,
        obscureText: widget.security,
        decoration: InputDecoration(
          labelText: widget.title,
          hintText: widget.hintText,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(),
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
        style: TextStyle(
          fontFamily: "Poppins",
        ),
        maxLines: widget.maxLines,
      ),
    );
  }
}
