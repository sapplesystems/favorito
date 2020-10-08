import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/toggleSwitch.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
// import 'package:Favorito/utils/myString.Dart';

class appoinmentSetting extends StatefulWidget {
  @override
  _appoinmentSettingState createState() => _appoinmentSettingState();
}

class _appoinmentSettingState extends State<appoinmentSetting> {
  List title = [
    "Waitlist Manager",
    "Anouncement",
    "Discription",
    "Minimum Wait Time",
    "Slot Length",
    "Except"
  ];
  List<String> slot = [
    "10",
    "10:30",
    "11",
    "11:30",
    "12",
    "12:30",
    "01",
    "01:30"
  ];
  SizeManager sm;
  List<String> list = ["Sunday", "Monday", "TuesDay", "WednesDay"];
  List<String> selectedList = [];
  List<TextEditingController> controller = [];

  void initState() {
    super.initState();
    for (int i = 0; i < 12; i++) controller.add(TextEditingController());
    controller[0].text = "0";
    controller[6].text = "0";
    controller[7].text = "0";
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: Color(0xfffff4f4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Appoinment Setting",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
        child: ListView(
          children: [
            Card(
                elevation: 8,
                shape: rrb,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: sm.scaledHeight(4),
                      horizontal: sm.scaledWidth(8)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        plusMinus("Advance Booking(Day)", controller[0]),
                        plusMinus("Advance Booking(Hours)", controller[1]),
                        DropdownSearch<String>(
                          validator: (v) => v == '' ? "required field" : null,
                          autoValidate: true,
                          mode: Mode.MENU,
                          selectedItem: controller[5].text,
                          items: slot,
                          label: "Slot Length",
                          hint: "Please Select Slot",
                          showSearchBox: false,
                          onChanged: (value) {
                            setState(() {
                              controller[5].text = value;
                            });
                          },
                        ),
                        plusMinus("Booking/Slot", controller[6]),
                        plusMinus("Booking/Day", controller[7]),
                        Padding(
                          padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
                          child: txtfieldboundry(
                            valid: true,
                            title: title[1],
                            hint: "Enter ${title[0]}",
                            controller: controller[3],
                            maxLines: 4,
                            security: false,
                          ),
                        ),
                        additionalFunction("Person"),
                        additionalFunction("Services"),
                        additionalFunction("Restrictions"),
                      ]),
                )),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: sm.scaledWidth(16),
                    vertical: sm.scaledHeight(2)),
                child: roundedButton(
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Done"))
          ],
        ),
      ),
    );
  }

  Widget fromTo(String txt) {
    return Container(
      margin: EdgeInsets.all(8),
      width: sm.scaledWidth(24),
      height: sm.scaledHeight(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: myRed,
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          txt,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget plusMinus(String _title, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("\n$_title", style: TextStyle(color: Colors.grey)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: myRed, size: 28),
            onPressed: () {
              int a = int.parse(ctrl.text);
              a = a > 0 ? a - 1 : a;
              setState(() => ctrl.text = a.toString());
            },
          ),
          fromTo(ctrl.text),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
            onPressed: () {
              setState(() => ctrl.text = (int.parse(ctrl.text) + 1).toString());
            },
          )
        ]),
      )
    ]);
  }

  addNewLabel(String s, labelClicked) {
    return InkWell(
      onTap: labelClicked,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(s, style: geryTextSmall),
        Text("Add New", style: redTextSmall)
      ]),
    );
  }

  labelClicked(String i) {
    switch (i) {
      case "0":
        {
          //statements;
        }
        break;
      case "1":
        {
          //statements;
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  int i;
  additionalFunction(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        addNewLabel(title, labelClicked(i.toString())),
        for (i = 0; i < 2; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title $i"),
              ToggleSwitch(
                switchControl: false,
              )
            ],
          )
      ]),
    );
  }
}
