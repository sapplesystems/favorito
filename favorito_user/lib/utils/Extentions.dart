import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension CustomExtention on Widget {
  Widget center() => Center(child: this);

  Widget safe() => SafeArea(child: this);
}

extension StringExtension on String {
  // String capitalize() {
  //   if (this.isEmpty) {
  //     return this;
  //   }
  //   var txt = '';
  //   var rawTxt = this.split(' ');
  //   for (int i = 0; i < rawTxt.length; i++) {
  //     txt = txt ??
  //         '' + ' ' + (rawTxt[i])[0]?.toUpperCase() ??
  //         '' + (rawTxt[i])?.substring(1) ??
  //         '';
  //   }
  //   print("Capital txt:${txt.trim()}");
  //   return txt.trim();
  // }

  String capitalize() {
    if (this.isEmpty || this.trim().length == 0) return this;
    return this
        .trim()
        .split(' ')
        .map((word) => (word.substring(0, 1).toUpperCase()) + word.substring(1))
        .join(' ');
  }

  // String sentenseCase() {
  //   // if (this.isEmpty) return this;
  //   return this
  //       .trim()
  //       .split('.')
  //       .map((word) => (word.substring(0, 1).toUpperCase()) + word.substring(1))
  //       .join(' ');
  // }

  String convert24to12() {
    int hh = int.parse(this.substring(0, 2));
    String turn = 12 > hh ? 'am' : 'pm';
    return "${hh > 12 ? hh - 12 : hh} $turn";
  }
}



