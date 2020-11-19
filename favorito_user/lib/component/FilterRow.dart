import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/SearchFilterList.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FilterRow extends StatefulWidget {
  List<ServiceFilterList> allFilters;
  List<String> selectedFilters;
  Function doneFunction;

  FilterRow(this.allFilters, this.selectedFilters, this.doneFunction);

  _FilterRow createState() => _FilterRow();
}

class _FilterRow extends State<FilterRow> {
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Container(
      child: Container(
        height: sm.scaledHeight(40),
        width: sm.scaledWidth(80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: sm.scaledHeight(40),
              width: sm.scaledWidth(80),
              child: ListView(
                children: [
                  for (var i = 0; i < widget.allFilters.length; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.allFilters[i].filter),
                        Switch(
                          value: widget.allFilters[i].selected,
                          onChanged: (value) {
                            setState(() {
                              widget.allFilters[i].selected = value;
                              if (value) {
                                widget.selectedFilters
                                    .add(widget.allFilters[i].filter);
                              } else {
                                widget.selectedFilters
                                    .remove(widget.allFilters[i].filter);
                              }
                            });
                          },
                          activeTrackColor: Colors.grey,
                          activeColor: myButtonBackground,
                        )
                      ],
                    )
                ],
              ),
            ),
            NeumorphicButton(
              style: NeumorphicStyle(
                  shape: NeumorphicShape.convex,
                  depth: 4,
                  lightSource: LightSource.topLeft,
                  color: myButtonBackground),
              margin: EdgeInsets.symmetric(horizontal: sm.scaledWidth(10)),
              boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.all(Radius.circular(24.0))),
              onClick: () {
                widget.doneFunction();
                Navigator.of(context).pop();
              },
              isEnabled: true,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.w400, color: myRed),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
