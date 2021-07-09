import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class txtfieldboundry extends StatefulWidget {
  String title;
  String hint;
  bool security;
  bool valid;
  bool isEnabled;
  int maxLines;
  int maxlen;
  TextInputType keyboardSet;
  TextEditingController controller;
  Function myOnChanged;
  RegExp myregex;
  Function prefClick;
  String prefix;
  String error;
  FocusNode focusNode;
  var inputTextSize;

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
      this.prefClick,
      this.error,
      this.prefix,
      this.focusNode,
      this.inputTextSize});
  @override
  _txtfieldboundryState createState() => _txtfieldboundryState();
}

class _txtfieldboundryState extends State<txtfieldboundry> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.security,
        maxLength: widget.maxlen,
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: sm.h(2.4), horizontal: sm.w(4)),
            errorText: widget.error,
            labelText: widget.title,
            labelStyle: TextStyle(color: myGrey, fontFamily: 'Gilroy-Regular'),
            counterText: "",
            hintText: widget.hint,
            prefix: Text(widget.prefix ?? ''),
            hintStyle: TextStyle(color: myGrey, fontFamily: 'Gilroy-Regular'),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide())),
        validator: (value) =>
            _validation(value, widget.valid, widget.title, widget.myregex),
        keyboardType: widget.keyboardSet,
        style: Theme.of(context).textTheme.body1.copyWith(
            fontSize: widget.inputTextSize != null
                ? double.parse("${widget.inputTextSize}")
                : 16.0),
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
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
