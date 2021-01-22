import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

import 'package:outline_gradient_button/outline_gradient_button.dart';
import '../config/SizeManager.dart';

class TimePicker extends StatefulWidget {
  TimePicker(
      {Key key, this.selectedTime, this.onChanged, this.selectedTimeText})
      : super(key: key);
  TimeOfDay selectedTime;
  final Function(String) onChanged;
  String selectedTimeText;
  @override
  _TimePicker createState() => _TimePicker();
}

class _TimePicker extends State<TimePicker> {
  MaterialLocalizations localizations;
  SizeManager sm;
  static const _YEAR = 365;
  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    localizations = MaterialLocalizations.of(context);
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    ).then((value) {
      setState(() {
        widget.selectedTimeText =
            localizations.formatTimeOfDay(value, alwaysUse24HourFormat: true);
      });
      print("picked ${widget.selectedTimeText.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Expanded(
          child: InkWell(
              onTap: () => _selectDate(context),
              child: SizedBox(
                width: sm.h(40),
                child: OutlineGradientButton(
                  child: Center(child: Text(widget.selectedTimeText)),
                  gradient: LinearGradient(colors: [myGrey, myGrey]),
                  strokeWidth: 1,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  radius: Radius.circular(8),
                ),
              )))
    ]);
  }
}
