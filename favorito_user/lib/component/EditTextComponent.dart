import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';

class EditTextComponent extends StatefulWidget {
  String title;
  String hint;
  bool security;
  int maxLines;
  int maxlen;
  bool valid;
  bool isEnabled;
  TextInputType keyboardSet;
  TextInputAction keyBoardAction;
  TextEditingController controller;
  RegExp myregex;
  String prefixIcon;
  FilteringTextInputFormatter formate;
  Function prefClick;
  Function myOnChanged;
  Function atSubmit;
  Function suffixTap;
  String error;
  Color errorColor;
  String suffixTxt;
  EditTextComponent(
      {this.title,
      this.security,
      this.hint,
      this.controller,
      this.formate,
      this.maxlen,
      this.keyboardSet,
      this.keyBoardAction,
      this.myregex,
      this.valid,
      this.isEnabled,
      this.maxLines,
      this.myOnChanged,
      this.prefClick,
      this.prefixIcon,
      this.atSubmit,
      this.suffixTxt,
      this.suffixTap,
      this.error,
      this.errorColor});
  @override
  _EditTextComponentState createState() => _EditTextComponentState();
}

class _EditTextComponentState extends State<EditTextComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: -8,
            lightSource: LightSource.topLeft,
            color: myEditTextBackground,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(30.0)))),
        child: Container(
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.security,
            maxLength: widget.maxlen,
            inputFormatters: [
              widget.formate ?? FilteringTextInputFormatter.singleLineFormatter
            ],
            decoration: InputDecoration(
              suffix: InkWell(
                  onTap: () => widget.suffixTap(),
                  child: Text(widget.suffixTxt ?? '')),
              prefixIcon: widget.prefixIcon == 'mail'
                  ? InkWell(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        child: SvgPicture.asset("assets/icon/enovelop.svg",
                            fit: BoxFit.fill, height: 1, width: 1),
                      ),
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
                                  : widget.prefixIcon == 'postal'
                                      ? InkWell(
                                          child: Icon(Icons.location_searching),
                                          onTap: () => widget.prefClick())
                                      : widget.prefixIcon == 'address'
                                          ? InkWell(
                                              child: Icon(Icons.home_outlined),
                                              onTap: () => widget.prefClick())
                                          : widget.prefixIcon == 'pincode'
                                              ? InkWell(
                                                  child: Icon(Icons.dialpad),
                                                  onTap: () =>
                                                      widget.prefClick())
                                              : null,
              counterText: "",
              hintText: widget.hint ?? '',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.only(top: 14, right: 16),
              fillColor: Colors.transparent,
              border: InputBorder.none,
            ),
            autofocus: false,
            keyboardType: widget.keyboardSet,
            textInputAction: widget.keyBoardAction,
            style: TextStyle(fontFamily: "Poppins"),
            maxLines: widget.maxLines ?? 1,
            onChanged: widget.myOnChanged,
            enabled: widget.isEnabled,
            onFieldSubmitted: widget.atSubmit,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 50),
        child: Text(
          widget.error ?? '',
          style: TextStyle(color: widget.errorColor ?? myRed),
          textAlign: TextAlign.left,
        ),
      )
    ]);
  }
}
