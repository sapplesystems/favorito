import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class WorkingDateTime extends StatefulWidget {
  // bool selected = false;
  TextEditingController controller = TextEditingController();
  List<bool> tempState = [];
  Map<String, String> selecteddayList;

  WorkingDateTime({this.selecteddayList});

  @override
  _WorkingDateTimeState createState() => _WorkingDateTimeState();
}

class _WorkingDateTimeState extends State<WorkingDateTime> {
  List<String> daylist = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  SizeManager sm;
  var _daysSelectedList = [false, false, false, false, false, false, false];
  String _startTime = '';
  String _endTime = '';
  MaterialLocalizations localizations;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < daylist.length; i++) {
      widget.tempState.add(widget.selecteddayList.containsKey(daylist[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    localizations = MaterialLocalizations.of(context);
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.only(top: 10.0),
            decoration: bd1,
            child: Column(children: [
              Expanded(
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [for (int i = 0; i < 7; i++) days(i)]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  InkWell(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child,
                            );
                          },
                        ).then((value) {
                          setState(() {
                            _startTime = localizations.formatTimeOfDay(value,
                                alwaysUse24HourFormat: true);
                          });
                        });
                      },
                      child: fromTo(txt: _startTime, clr: myGrey)),
                  Text("-", style: TextStyle(fontSize: 40)),
                  InkWell(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child,
                            );
                          },
                        ).then((value) {
                          setState(() {
                            // _endTime = value.format(context);
                            _endTime = localizations.formatTimeOfDay(value,
                                alwaysUse24HourFormat: true);
                          });
                        });
                      },
                      child: fromTo(txt: _endTime, clr: myGrey))
                ]),
              ),
              InkWell(
                  onTap: () => funAdd(), child: fromTo(txt: "Add", clr: myRed))
            ])),
        Positioned(
          right: -14,
          top: -14,
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.highlight_off_outlined, color: myRed)),
        ),
      ],
    );
  }

  days(int j) {
    return InkWell(
      onTap: () {
        setState(() {
          if (!widget.tempState[j]) {
            if (_daysSelectedList[j])
              _daysSelectedList[j] = false;
            else
              _daysSelectedList[j] = true;
          }
        });
      },
      child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: widget.tempState[j]
                  ? myGrey
                  : _daysSelectedList[j]
                      ? myRed
                      : Colors.white,
              border: Border.all(width: 1.0, color: myGrey),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(children: [
              Text(
                daylist[j],
                style: TextStyle(
                  color: widget.tempState[j]
                      ? Colors.white
                      : _daysSelectedList[j]
                          ? Colors.white
                          : myGrey,
                ),
              ),
              Icon(Icons.done, color: Colors.white)
            ]),
          )),
    );
  }

  funAdd() {
    for (int i = 0; i < _daysSelectedList.length; i++) {
      if (_startTime != null &&
          _startTime != "" &&
          _endTime != null &&
          _endTime != "")
        setState(() {
          if (_daysSelectedList[i])
            widget.selecteddayList[daylist[i]] = "$_startTime - $_endTime";
          else
            widget.selecteddayList.remove([daylist[i]]);
        });
      else {
        BotToast.showText(text: "Please select start and end times.");
        return;
      }
    }
    Navigator.pop(context);
    print("selected dated is :${widget.selecteddayList.toString()}");
  }
}
