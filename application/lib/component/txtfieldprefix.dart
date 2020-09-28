import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class txtfieldprefix extends StatefulWidget {
  String title;
  String hint;
  bool security;
  int maxLines;
  int maxlen;
  bool valid;
  TextInputType keyboardSet;
  TextEditingController ctrl;
  IconData prefixIco;
  Function myOnChanged;
  RegExp myregex;
  Function prefClick;
  txtfieldprefix(
      {this.title,
      this.security,
      this.hint,
      this.ctrl,
      this.maxlen,
      this.keyboardSet,
      this.myregex,
      this.valid,
      this.maxLines,
      this.myOnChanged,
      this.prefixIco,
      this.prefClick});
  @override
  _txtfieldprefixState createState() => _txtfieldprefixState();
}

class _txtfieldprefixState extends State<txtfieldprefix> {
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
            prefixIcon: IconButton(
              icon: Icon(widget.prefixIco),
              onPressed: () {
                if (widget.prefixIco != null) {
                  widget.prefClick();
                }
              },
            ),
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
