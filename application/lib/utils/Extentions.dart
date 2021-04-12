import 'package:flutter/material.dart';

extension CustomExtention on Widget {
  Widget center() => Center(child: this);

  Widget padAll(double a) => Padding(padding: EdgeInsets.all(a));

  Widget padL(double l) => Padding(padding: EdgeInsets.only(left: l));

  Widget padR(double r) => Padding(padding: EdgeInsets.only(right: r));

  Widget padLR(double l, double r) =>
      Padding(padding: EdgeInsets.only(left: l, right: r));

  Widget padT(double t) => Padding(padding: EdgeInsets.only(top: t));

  Widget padB(double b) => Padding(padding: EdgeInsets.only(bottom: b));

  Widget padTB(double t, double b) =>
      Padding(padding: EdgeInsets.only(top: t, bottom: b));

  Widget padTL(double t, double l) =>
      Padding(padding: EdgeInsets.only(top: t, left: l));

  Widget padTR(double t, double r) =>
      Padding(padding: EdgeInsets.only(top: t, right: r));

  Widget padBL(double b, double l) =>
      Padding(padding: EdgeInsets.only(bottom: b, left: l));

  Widget padBR(double b, double r) =>
      Padding(padding: EdgeInsets.only(bottom: b, right: r));

  Widget padRTL(double r, double t, double l) =>
      Padding(padding: EdgeInsets.only(right: r, top: t, left: l));

  Widget safe() => SafeArea(child: this);
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeManner() {
    if (this.isEmpty || this.trim().length == 0) return this;
    return this
        .trim()
        .split(' ')
        .map((word) => (word.substring(0, 1).toUpperCase()) + word.substring(1))
        .join(' ');
  }

  String convert24to12() {
    int hh = int.parse(this.substring(0, 2));
    String turn = 12 > hh ? 'am' : 'pm';
    print("HH:${hh.toString()}${turn.toLowerCase()}");
    return "${hh > 12 ? hh - 12 : hh} $turn";
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addHour(int hour) {
    return this.replacing(hour: this.hour + hour, minute: this.minute);
  }
}

// ProgressDialog pr;

// extension MyDialog on ProgressDialog {
//   loader(BuildContext context, String message) {
//     pr = ProgressDialog(context,
//         type: ProgressDialogType.Normal, isDismissible: false);
//     pr.style(message: 'Please wait');
//     pr.show();
//   }

//   void show() {
//     // pr.hide();
//   }
// }
