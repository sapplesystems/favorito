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
  String error;
  FocusNode focusNode;

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
      this.focusNode});
  @override
  _txtfieldboundryState createState() => _txtfieldboundryState();
}

class _txtfieldboundryState extends State<txtfieldboundry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.security,
        maxLength: widget.maxlen,
        decoration: InputDecoration(
            errorText: widget.error,
            labelText: widget.title,
            labelStyle: Theme.of(context).textTheme.body2,
            counterText: "",
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.subhead,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide())),
        // validator: (value) =>
        //     _validation(value, widget.valid, widget.title, widget.myregex),
        keyboardType: widget.keyboardSet,
        style: Theme.of(context).textTheme.body1,
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
