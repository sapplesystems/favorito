import 'package:favorito_user/config/SizeManager.dart';
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
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    Color color =
        NeumorphicTheme.isUsingDark(context) ? Colors.white : Colors.black;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: -48,
            lightSource: LightSource.topLeft,
            color:
                (MediaQuery.of(context).platformBrightness != Brightness.dark)
                    ? myBackGround
                    : null,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(30.0)))),
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.security,
          maxLength: widget.maxlen,
          inputFormatters: [
            widget.formate ?? FilteringTextInputFormatter.singleLineFormatter
          ],
          decoration: InputDecoration(
              labelStyle:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 12),
              suffix: InkWell(
                  onTap: () => widget.suffixTap(),
                  child: Text(
                    widget.suffixTxt ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
                  )),
              prefixIcon: widget.prefixIcon == 'mail'
                  ? InkWell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
                          child: SvgPicture.asset("assets/icon/enovelop.svg",
                              color: color,
                              fit: BoxFit.fill,
                              height: 1,
                              width: 1)),
                      onTap: () {},
                    )
                  : widget.prefixIcon == 'password'
                      ? InkWell(
                          child: Icon(Icons.lock_outline, color: color),
                          onTap: () {},
                        )
                      : widget.prefixIcon == 'name'
                          ? InkWell(
                              child: Container(
                                  margin: EdgeInsets.all(sm.h(1.9)),
                                  child: SvgPicture.asset(
                                      'assets/icon/fullname.svg',
                                      color: color)),
                              onTap: () {},
                            )
                          : widget.prefixIcon == 'phone'
                              ? InkWell(
                                  child: Container(
                                      margin: EdgeInsets.all(sm.h(1.9)),
                                      child: SvgPicture.asset(
                                          'assets/icon/phone.svg',
                                          color: color)),
                                  onTap: () {},
                                )
                              : widget.prefixIcon == 'search'
                                  ? InkWell(
                                      child: Icon(Icons.search, color: color),
                                      onTap: () => widget.prefClick(),
                                    )
                                  : widget.prefixIcon == 'postal'
                                      ? InkWell(
                                          child: Container(
                                              margin: EdgeInsets.all(sm.h(1.9)),
                                              child: SvgPicture.asset(
                                                  'assets/icon/location.svg',
                                                  color: color)),
                                          onTap: () => widget.prefClick())
                                      : widget.prefixIcon == 'address'
                                          ? InkWell(
                                              child: Icon(Icons.home_outlined,
                                                  color: color),
                                              onTap: () => widget.prefClick())
                                          : widget.prefixIcon == 'pincode'
                                              ? InkWell(
                                                  child: Icon(Icons.dialpad,
                                                      color: color),
                                                  onTap: () =>
                                                      widget.prefClick())
                                              : null,
              counterText: "",
              hintText: widget.hint ?? '',
              alignLabelWithHint: true,
              // hintStyle: Theme.of(context).textTheme.headline6.copyWith(
              // color: Colors.black,
              //     fontSize: 18,
              //     textBaseline: TextBaseline.alphabetic),
              contentPadding: EdgeInsets.only(
                  top: (widget.maxLines ?? 1) > 1 ? 14 : 14,
                  right: 16,
                  left: 16),
              fillColor: Colors.transparent,
              border: InputBorder.none),
          autofocus: false,
          focusNode: null,
          keyboardType: widget.keyboardSet,
          textInputAction: widget.keyBoardAction,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
          maxLines: widget.maxLines ?? 1,
          onChanged: widget.myOnChanged,
          enabled: widget.isEnabled,
          onFieldSubmitted: widget.atSubmit,
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
