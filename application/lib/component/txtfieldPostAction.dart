import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class txtfieldPostAction extends StatefulWidget {
  String title;
  String hint;
  bool security;
  int maxLines;
  int maxlen;
  bool valid;
  TextInputType keyboardSet;
  TextEditingController controller;
  IconData sufixIcon;
  Function myOnChanged;
  RegExp myregex;
  Function sufixClick;
  String sufixTxt;
  String errorText;
  Color sufixColor;

  txtfieldPostAction(
      {this.title,
      this.security,
      this.hint,
      this.controller,
      this.maxlen,
      this.keyboardSet,
      this.myregex,
      this.valid,
      this.maxLines,
      this.myOnChanged,
      this.sufixClick,
      this.sufixColor,
      this.sufixTxt,
      this.errorText,
      this.sufixIcon});
  @override
  _txtfieldPostActionState createState() => _txtfieldPostActionState();
}

class _txtfieldPostActionState extends State<txtfieldPostAction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.security,
        maxLength: widget.maxlen,
        decoration: InputDecoration(
          errorText: widget.errorText ?? '',
          labelText: widget.title,
          counterText: "",
          suffix: InkWell(
              onTap: () => widget.sufixClick(),
              child: widget.sufixTxt == null
                  ? Icon(widget.sufixIcon,
                      size: 22,
                      semanticLabel: "",
                      textDirection: TextDirection.ltr,
                      color: widget.sufixColor != null
                          ? widget.sufixColor
                          : Colors.blue)
                  : Text(
                      widget.sufixTxt,
                      style: TextStyle(
                          color: widget.sufixColor != null
                              ? widget.sufixColor
                              : Colors.blue),
                    )),
          hintText: widget.hint,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: myGrey),
          ),
        ),
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

  String _validation(String text, bool valid, String lbl, RegExp myregex) {
    if (valid) {
      if (myregex != null && text.isNotEmpty)
        return myregex.hasMatch(text) ? null : "$pleaseEnterValid $lbl";
      else
        return text.isEmpty ? "$pleaseEnter $lbl" : null;
    }
  }
}
