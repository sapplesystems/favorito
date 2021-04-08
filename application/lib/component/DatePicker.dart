import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/SizeManager.dart';

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
      widget.onChanged(DateFormat('yyyy-MM-dd').format(picked).toString());
      widget.selectedDateText = DateFormat.yMMMd().format(picked);
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
                width: sm.w(40),
                // child: OutlineGradientButton(
                //   child: Center(child: Text(widget.selectedDateText)),
                //   gradient: LinearGradient(colors: [myGrey, myGrey]),
                //   strokeWidth: 1,
                //   padding: EdgeInsets.symmetric(vertical: 12),
                //   radius: Radius.circular(8),
                // ),
              )))
    ]);
  }
}
