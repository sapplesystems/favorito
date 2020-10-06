import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class txtfieldboundry extends StatefulWidget {
  String title;
  String hint;
  bool security;
  int maxLines;
  int maxlen;
  bool valid;
  bool isEnabled;
  TextInputType keyboardSet;
  TextEditingController controller;
  Function myOnChanged;
  RegExp myregex;
  Function prefClick;
  txtfieldboundry(
      {this.title,
      this.security,
      this.hint,
      this.controller,
      this.maxlen,
      this.keyboardSet,
      this.myregex,
      this.valid,
      this.isEnabled,
      this.maxLines,
      this.myOnChanged,
      this.prefClick});
  @override
  _txtfieldboundryState createState() => _txtfieldboundryState();
}

class _txtfieldboundryState extends State<txtfieldboundry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.security,
        maxLength: widget.maxlen,
        decoration: InputDecoration(
            labelText: widget.title,
            counterText: "",
            hintText: widget.hint,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide())),
        validator: (value) =>
            _validation(value, widget.valid, widget.title, widget.myregex),
        keyboardType: widget.keyboardSet,
        style: TextStyle(
          fontFamily: "Poppins",
        ),
        maxLines: widget.maxLines,
        onChanged: widget.myOnChanged,
        enabled: widget.isEnabled,
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
