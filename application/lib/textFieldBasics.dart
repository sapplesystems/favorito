import 'package:Favorito/ObjectFieldsBasic.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class textFieldBasics extends StatelessWidget {
  ObjectFieldsBasic buttonsOne;
  textFieldBasics({this.buttonsOne});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: buttonsOne.visib,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 2)),
        margin: EdgeInsets.only(top: 8),
        child: TextFormField(
          keyboardType: buttonsOne.inputType,
          enabled: buttonsOne.enabls,
          controller: buttonsOne.control,
          maxLength: buttonsOne.maxlen,
          readOnly: buttonsOne.readOnly,
          obscureText: buttonsOne.secure,
          maxLines: buttonsOne.maxlines,
          decoration: InputDecoration(
            counterText: "",
            labelText: buttonsOne.label,
            labelStyle: TextStyle(color: buttonsOne.labelcolor),
            hintText: buttonsOne.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(buttonsOne.iconVal, color: buttonsOne.labelcolor),
            suffixIcon: Icon(
              buttonsOne.suffixIcon,
              color: buttonsOne.labelcolor,
            ),
          ),
          focusNode: buttonsOne.from,
          textCapitalization: TextCapitalization.words,
          validator: (value) => _validation(
              value, buttonsOne.valid, buttonsOne.label, buttonsOne.myregex),
          onFieldSubmitted: buttonsOne.fieldSubmit,
          onTap: buttonsOne.onTaped,
        ),
      ),
    );
  }

  // ignore: missing_return
  String _validation(String text, bool valid, String lbl, RegExp myregex) {
    if (valid) {
      if (myregex != null)
        return myregex.hasMatch(text) ? null : "Please Enter $lbl";
      else
        return text.isEmpty ? "Please Enter $lbl" : null;
    }
  }
}
