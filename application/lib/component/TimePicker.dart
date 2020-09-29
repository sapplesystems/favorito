import 'package:flutter/material.dart';

import 'package:outline_gradient_button/outline_gradient_button.dart';

import '../config/SizeManager.dart';

class TimePicker extends StatefulWidget {
  TimePicker(
      {Key key, this.selectedTime, this.onChanged, this.selectedTimeText})
      : super(key: key);
  TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onChanged;
  String selectedTimeText;
  @override
  _TimePicker createState() => _TimePicker();
}

class _TimePicker extends State<TimePicker> {
  SizeManager sm;
  static const _YEAR = 365;
  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(milliseconds: 100));
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: widget.selectedTime,
    );
    if (picked != null && picked != widget.selectedTime) {
      // widget.onChanged(picked);
      widget.selectedTimeText = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Expanded(
          child: InkWell(
              onTap: () => _selectDate(context),
              child: SizedBox(
                width: sm.scaledHeight(40),
                child: OutlineGradientButton(
                  child: Center(child: Text(widget.selectedTimeText)),
                  gradient: LinearGradient(colors: [Colors.red, Colors.red]),
                  strokeWidth: 1,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  radius: Radius.circular(8),
                ),
              )))
    ]);
  }
}
