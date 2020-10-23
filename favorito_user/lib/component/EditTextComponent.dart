import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditTextComponent extends StatefulWidget {
  String title;
  String hint;
  bool security;
  int maxLines;
  int maxlen;
  bool valid;
  bool isEnabled;
  TextInputType keyboardSet;
  TextEditingController ctrl;
  Function myOnChanged;
  RegExp myregex;
  Function prefClick;
  String prefixIcon;
  EditTextComponent(
      {this.title,
      this.security,
      this.hint,
      this.ctrl,
      this.maxlen,
      this.keyboardSet,
      this.myregex,
      this.valid,
      this.isEnabled,
      this.maxLines,
      this.myOnChanged,
      this.prefClick,
      this.prefixIcon});
  @override
  _EditTextComponentState createState() => _EditTextComponentState();
}

class _EditTextComponentState extends State<EditTextComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: -8,
            lightSource: LightSource.topLeft,
            color: myEditTextBackground),
        boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.all(Radius.circular(30.0))),
        child: TextFormField(
          controller: widget.ctrl,
          obscureText: widget.security,
          maxLength: widget.maxlen,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon == 'mail'
                ? InkWell(
                    child: Icon(Icons.mail_outline),
                    onTap: () {},
                  )
                : widget.prefixIcon == 'password'
                    ? InkWell(
                        child: Icon(Icons.lock_outline),
                        onTap: () {},
                      )
                    : widget.prefixIcon == 'name'
                        ? InkWell(
                            child: Icon(Icons.contacts),
                            onTap: () {},
                          )
                        : widget.prefixIcon == 'phone'
                            ? InkWell(
                                child: Icon(Icons.phone),
                                onTap: () {},
                              )
                            : widget.prefixIcon == 'search'
                                ? InkWell(
                                    child: Icon(Icons.search),
                                    onTap: () {
                                      widget.prefClick();
                                    },
                                  )
                                : null,
            labelText: widget.title,
            counterText: "",
            hintText: widget.hint,
            contentPadding: EdgeInsets.only(left: 16.0, top: 16.0),
            fillColor: Colors.transparent,
            border: InputBorder.none,
          ),
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
      ),
    );
  }

  // ignore: missing_return
  String _validation(String text, bool valid, String lbl, RegExp myregex) {
    if (valid) {
      if (myregex != null && text.isNotEmpty)
        return myregex.hasMatch(text) ? null : "$lbl";
      else
        return text.isEmpty ? "$lbl" : null;
    }
  }
}
