// import 'package:flutter/material.dart';
// import 'package:Favorito/utils/myString.Dart';

// class txtfieldPostIcon extends StatefulWidget {
//   String title;
//   String hint;
//   bool security;
//   int maxLines;
//   int maxlen;
//   bool valid;
//   TextInputType keyboardSet;
//   TextEditingController ctrl;
//   IconData sufixIcon;
//   Function myOnChanged;
//   RegExp myregex;
//   Function sufixClick;
//   Color sufixColor;

//   txtfieldPostIcon(
//       {this.title,
//       this.security,
//       this.hint,
//       this.ctrl,
//       this.maxlen,
//       this.keyboardSet,
//       this.myregex,
//       this.valid,
//       this.maxLines,
//       this.myOnChanged,
//       this.sufixClick,
//       this.sufixColor,
//       this.sufixIcon});
//   @override
//   _txtfieldPostIconState createState() => _txtfieldPostIconState();
// }

// class _txtfieldPostIconState extends State<txtfieldPostIcon> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: TextFormField(
//         controller: widget.ctrl,
//         obscureText: widget.security,
//         maxLength: widget.maxlen,
//         decoration: InputDecoration(
//             labelText: widget.title,
//             counterText: "",
//             suffixIcon: InkWell(
//               onTap: widget.sufixClick,
//               child: Icon(widget.sufixIcon,
//                   color: widget.sufixColor != null
//                       ? widget.sufixColor
//                       : Colors.blue),
//             ),
//             hintText: widget.hint,
//             fillColor: Colors.transparent,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//                 borderSide: BorderSide())),
//         validator: (value) =>
//             _validation(value, widget.valid, widget.title, widget.myregex),
//         keyboardType: widget.keyboardSet,
//         style: TextStyle(
//           fontFamily: "Poppins",
//         ),
//         maxLines: widget.maxLines,
//         onChanged: widget.myOnChanged,
//       ),
//     );
//   }

//   // ignore: missing_return
//   String _validation(String text, bool valid, String lbl, RegExp myregex) {
//     if (valid) {
//       if (myregex != null && text.isNotEmpty)
//         return myregex.hasMatch(text) ? null : "$pleaseEnterValid $lbl";
//       else
//         return text.isEmpty ? "$pleaseEnter $lbl" : null;
//     }
//   }
// }
