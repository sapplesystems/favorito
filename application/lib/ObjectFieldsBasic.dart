import 'package:flutter/material.dart';

class ObjectFieldsBasic {
  TextEditingController control;
  String label;
  String hint;
  bool valid;
  bool focusAuto;
  FocusNode from;
  FocusNode to;
  TextInputType inputType;
  int maxlen;
  IconData iconVal;
  IconData suffixIcon;
  bool enabls;
  bool readOnly;
  Color labelcolor = Colors.blue;
  Function onTaped;
  ValueChanged<String> fieldSubmit;
  RegExp myregex;
  bool secure;
  int maxlines;
  bool visib;

  ObjectFieldsBasic(
      {this.control,
      this.label,
      this.valid = true,
      this.focusAuto,
      this.from,
      this.hint,
      this.inputType,
      this.maxlen,
      this.to,
      this.iconVal,
      this.enabls = true,
      this.readOnly = false,
      this.labelcolor,
      this.onTaped,
      this.fieldSubmit,
      this.suffixIcon,
      this.myregex,
      this.visib = true,
      this.secure = false,
      this.maxlines = 1});
}
