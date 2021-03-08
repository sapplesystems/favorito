import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextInputAction keyBoardAction;
  TextEditingController ctrl;
  RegExp myregex;
  String prefixIcon;
  FilteringTextInputFormatter formate;
  Function prefClick;
  Function myOnChanged;
  Function atSubmit;
  Function suffixTap;
  String error;
  String suffixTxt;
  EditTextComponent(
      {this.title,
      this.security,
      this.hint,
      this.ctrl,
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
      this.error});
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
        child: TextFormField(
          controller: widget.ctrl,
          obscureText: widget.security,
          maxLength: widget.maxlen,
          inputFormatters: [
            widget.formate ?? FilteringTextInputFormatter.singleLineFormatter
          ],
          decoration: InputDecoration(

            suffix: InkWell(
                onTap: () => widget.suffixTap(),
                child: Text(widget.suffixTxt ?? null)),
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
                                : widget.prefixIcon == 'postal'
                                    ? InkWell(
                                        child: Icon(Icons.location_searching),
                                        onTap: () {
                                          widget.prefClick();
                                        },
                                      )
                                    : widget.prefixIcon == 'address'
                                        ? InkWell(
                                            child: Icon(Icons.home_outlined),
                                            onTap: () {
                                              widget.prefClick();
                                            },
                                          )
                                        : null,
            labelText: '',
            counterText: "",
            hintText: widget.hint,
            contentPadding: EdgeInsets.only(top: -2),
            fillColor: Colors.transparent,
            border: InputBorder.none,
          ),
          keyboardType: widget.keyboardSet,
          textInputAction: widget.keyBoardAction,
          style: TextStyle(fontFamily: "Poppins"),
          maxLines: widget.maxLines ?? 1,
          onChanged: widget.myOnChanged,
          enabled: widget.isEnabled,
          onFieldSubmitted: widget.atSubmit,
        ),
      ),
      Text(
        widget.error ?? '',
        style: TextStyle(color: myRed),
        textAlign: TextAlign.left,
      )
    ]);
  }

  // ignore: missing_return

}
