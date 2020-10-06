import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class WorkingDateTime extends StatefulWidget {
  // bool selected = false;
  TextEditingController controller = TextEditingController();
  List<bool> _daysSelectedList = [];

  @override
  _WorkingDateTimeState createState() => _WorkingDateTimeState();
}

class _WorkingDateTimeState extends State<WorkingDateTime> {
  List<String> daylist = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  SizeManager sm;
  String _startTime = '';
  String _endTime = '';

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
      margin: EdgeInsets.only(top: 100),
      decoration: bd1,
      child: Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [for (int i = 0; i < 7; i++) days(i)]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    _startTime = value.format(context);
                  });
                  setState(() {});
                },
                child: fromTo(txt: _startTime, clr: myGrey)),
            Text('-', style: TextStyle(fontSize: 40)),
            InkWell(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    _endTime = value.format(context);
                  });
                  setState(() {});
                },
                child: fromTo(txt: _endTime, clr: myGrey)),
          ],
        ),
        fromTo(txt: "Add", clr: myRed),
      ]),
    );
  }

  days(int j) {
    widget._daysSelectedList.add(false);
    return InkWell(
      onTap: () {
        print(daylist[j]);
        setState(() {
          widget._daysSelectedList[j] = !widget._daysSelectedList[j];
        });
      },
      child: Card(
          elevation: 2,
          color: widget._daysSelectedList[j] ? myRed : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(children: [
              Text(
                daylist[j],
                style: TextStyle(
                    color: widget._daysSelectedList[j] ? Colors.white : myRed),
              ),
              Icon(Icons.done, color: Colors.white)
            ]),
          )),
    );
  }
}
