import 'package:flutter/material.dart';
import 'package:application/utils/myString.Dart';

class txtfieldboundry extends StatefulWidget {
  String title;
  String hint;
  bool security;
  int maxlen;
  bool valid;
  TextInputType keyboardSet;
  TextEditingController ctrl;
  RegExp myregex;
  txtfieldboundry(
      {this.title,
      this.security,
      this.hint,
      this.ctrl,
      this.maxlen,
      this.keyboardSet,
      this.myregex,
      this.valid});
  @override
  _txtfieldboundryState createState() => _txtfieldboundryState();
}

class _txtfieldboundryState extends State<txtfieldboundry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.ctrl,
        obscureText: widget.security,
        maxLength: widget.maxlen,
        decoration: InputDecoration(
          labelText: widget.title,
          counterText: "",
          hintText: widget.hint,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(),
          ),
          // fillColor: Colors.green
        ),
        validator: (value) =>
            _validation(value, widget.valid, widget.title, widget.myregex),
        keyboardType: widget.keyboardSet,
        style: TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }

  // ignore: missing_return
  String _validation(String text, bool valid, String lbl, RegExp myregex) {
    if (valid) {
      if (myregex != null && text.isNotEmpty)
        return myregex.hasMatch(text) ? null : "$pleaseEnterValid $lbl";
      else
        return text.isEmpty ? "$pleaseEnter $lbl" : null;
    }
  }
}
