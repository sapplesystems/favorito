import 'package:flutter/material.dart';

class MyRadioGroup extends StatefulWidget {
  Map dataList;
  String selected;
  MyRadioGroup({this.dataList, this.selected});
  @override
  _MyRadioGroupState createState() => _MyRadioGroupState();
}

class _MyRadioGroupState extends State<MyRadioGroup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < widget.dataList.values.toList().length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onFocusChange: (va) {
                  print("va$va");
                },
                onTap: () {
                  for (int j = 0;
                      j < widget.dataList.values.toList().length;
                      j++) {
                    if (i == j)
                      setState(() {
                        widget.dataList[widget.dataList.keys.toList()[j]] =
                            true;
                        widget.selected = widget.dataList.keys.toList()[j];
                      });
                    else
                      setState(() {
                        widget.dataList[widget.dataList.keys.toList()[j]] =
                            false;
                      });
                  }
                },
                child: Row(children: [
                  Icon(
                    widget.dataList.values.toList()[i]
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: widget.dataList.values.toList()[i]
                        ? Colors.red
                        : Colors.grey,
                  ),
                  Text(widget.dataList.keys.toList()[i],
                      style: TextStyle(
                          fontSize: 16,
                          color: widget.dataList.values.toList()[i]
                              ? Colors.red
                              : Colors.grey))
                ]),
              ),
            ),
        ],
      ),
    );
  }
}
