import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../config/SizeManager.dart';

import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  DatePicker(
      {Key key, this.selectedDate, this.onChanged, this.selectedDateText})
      : super(key: key);
  final DateTime selectedDate;
  final Function(String) onChanged;
  String selectedDateText;
  @override
  _DatePicker createState() => _DatePicker();
}

class _DatePicker extends State<DatePicker> {
  SizeManager sm;
  static const _YEAR = 365;
  Future<Null> _selectDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await Future.delayed(Duration(milliseconds: 100));
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: _YEAR * 20)),
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onChanged(DateFormat('dd/MM/yyyy').format(picked).toString());
      widget.selectedDateText = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return InkWell(
        onTap: () => _selectDate(context),
        child: Neumorphic(
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            depth: 8,
            lightSource: LightSource.top,
            color: Colors.white,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(8.0))),
          ),
          margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
          child: Center(
            child: Text(widget.selectedDateText,
                style: TextStyle(color: Colors.grey)),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ));
  }
}
