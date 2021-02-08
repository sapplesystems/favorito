import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/setting/BusinessProfile/Abc.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkingDateTime extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  List<bool> tempState = [];
  Map<String, String> selecteddayList;

  WorkingDateTime({this.selecteddayList});

  @override
  _WorkingDateTimeState createState() => _WorkingDateTimeState();
}

class _WorkingDateTimeState extends State<WorkingDateTime> {
  List<String> daylist = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<String> alredy = [];
  SizeManager sm;
  var _daysSelectedList = [false, false, false, false, false, false, false];
  String _startTime = '';
  String _endTime = '';
  MaterialLocalizations localizations;
  Map<String, String> _temp1 = {};
  @override
  void initState() {
    _temp1.addAll(widget.selecteddayList);
    super.initState();
    for (int i = 0; i < daylist.length; i++) {
      widget.tempState.add(widget.selecteddayList.containsKey(daylist[i]));
    }
    print("widget.selecteddayList:${widget.selecteddayList}");
    widget.selecteddayList.isNotEmpty
        ? widget.selecteddayList.addAll(widget.selecteddayList)
        : "";
    for (var _v in widget.selecteddayList?.keys.toList()) {
      alredy.add(_v);
    }

    for (var _v in alredy) {
      // print("aaaaa${_v}");
      if (_v.contains('-')) {
        int _start = daylist.indexOf(_v.split(' - ')[0]);
        int _end = daylist.indexOf(_v.split(' - ')[1]);
        print("aaaaa${_start}");
        print("aaaaa${_end}");
        for (int i = _start; i <= _end; i++) {
          widget.tempState[i] = true;
        }
      } else {
        widget.tempState[daylist.indexOf(_v.split(' - ')[0])] = true;
        // int _start = daylist.indexOf(_v);
        // _daysSelectedList[_start] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    localizations = MaterialLocalizations.of(context);
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.only(top: 20.0),
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
          print("widget.tempState[j]:${widget.tempState[j]}");
          // if (!widget.tempState[j]) {
          print("_daysSelectedList[j]:${_daysSelectedList[j]}");
          if (_daysSelectedList[j]) {
            print("widget1");
            _daysSelectedList[j] = false;
          } else {
            print("widget12");
            _daysSelectedList[j] = true;
          }
          // }
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
          _endTime != "") {
        if (_daysSelectedList[i])
          widget.selecteddayList[daylist[i]] = "$_startTime - $_endTime";
        else
          widget.selecteddayList.remove([daylist[i]]);
      } else {
        BotToast.showText(text: "Please select start and end times.");
        return;
      }

      print("_daysSelectedList:${widget.selecteddayList.toString()}");
    }

    // businessHoursBallancer() {
    List ls = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    List<Abc> list = [];

    List<Abc> list2 = [];
    List<Abc> list3 = [];
    // Map<String, String> selecteddayList = {
    //   "Mon": "12:22 - 14:22",
    //   "Wed": "16:23 - 21:23",
    //   "Thu": "12:22 - 14:22",
    //   "Tue": "12:22 - 14:22",
    //   "Fri": "12:22 - 14:22",
    //   "Sat": "16:23 - 21:23",
    //   "Sun": "16:23 - 21:23"
    // };
    for (int i = 0; i < widget.selecteddayList.length; i++) {
      Abc abc = Abc();
      abc.day = widget.selecteddayList.keys.toList()[i];
      abc.start =
          (widget.selecteddayList[widget.selecteddayList.keys.toList()[i]])
              .substring(0, 5);
      abc.end =
          (widget.selecteddayList[widget.selecteddayList.keys.toList()[i]])
              .substring(8, 13);
      list.add(abc);
    }
    for (int _i = 0; _i < ls.length; _i++) {
      for (int _j = 0; _j < list.length; _j++) {
        if (ls[_i] == list[_j].day) {
          list3.add(list[_j]);
        } else {
          // list3.add(Abc());
        }
      }
    }

    list2 = [];
    var counter = 0;
    for (int i = 0; i < list3.length; i++) {
      // if (list3[i].day != null) {
      if (i < list3.length - 1 &&
          list3[i].start == list3[i + 1].start &&
          list3[i].end == list3[i + 1].end &&
          (ls.indexOf(list3[i].day) - ls.indexOf(list3[i + 1].day)) == -1) {
        counter++;
        if (counter == 1) {
          list2.add(
              Abc(start: list3[i].start, end: list3[i].end, day: list3[i].day));
        }
      } else {
        if (counter == 0) {
          list2.add(
              Abc(start: list3[i].start, end: list3[i].end, day: list3[i].day));
        } else {
          list2[list2.length - 1].day =
              "${list2[list2.length - 1].day} - ${list3[i].day}";
          counter = 0;
        }
        // }
      }
    }

    // print(list2.length);
    widget.selecteddayList.clear();

    Map<String, String> _temp = {};
    for (var v in list2) _temp[v.day] = "${v.start} - ${v.end}";

    _temp1?.addAll(_temp);
    // }
    widget.selecteddayList.addAll(_temp1);
    Navigator.pop(context);
  }
}
