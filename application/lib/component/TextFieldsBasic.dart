import 'package:Favorito/ObjectFieldsBasic.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

// ignore: must_be_immutable
class TextFieldsBasic extends StatelessWidget {
  ObjectFieldsBasic buttonsOne;
  TextFieldsBasic({this.buttonsOne});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: buttonsOne.visib,
      child: Container(
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
            // border:
            //     buttonsOne.inputBorder != null ? buttonsOne.inputBorder : null,
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
      if (myregex != null && text.isNotEmpty)
        return myregex.hasMatch(text) ? null : "$pleaseEnterValid $lbl";
      else
        return text.isEmpty ? "$pleaseEnter $lbl" : null;
    }
  }
}
