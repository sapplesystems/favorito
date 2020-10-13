import 'package:Favorito/component/TxtBorder.dart';
import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class WaitListSetting extends StatefulWidget {
  @override
  _WaitListSettingState createState() => _WaitListSettingState();
}

class _WaitListSettingState extends State<WaitListSetting> {
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
    controller[2].text = "0";
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
          waitlistSetting,
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
                        Text("Start waitlist daily at",
                            style: TextStyle(color: Colors.grey)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            fromTo(txt: "18:00", clr: myRed),
                            fromTo(txt: "18:00", clr: myRed)
                          ],
                        ),
                        plusMinus("Available resources", controller[2]),
                        Padding(
                          padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
                          child: txtfieldboundry(
                            valid: true,
                            title: title[3],
                            hint: "Enter ${title[0]}",
                            controller: controller[3],
                            maxLines: 1,
                            security: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
                          child: txtfieldboundry(
                            valid: true,
                            title: title[4],
                            hint: "Enter ${title[4]}",
                            controller: controller[4],
                            maxLines: 1,
                            security: false,
                          ),
                        ),
                        DropdownSearch<String>(
                          validator: (v) => v == '' ? "required field" : null,
                          autoValidate: true,
                          mode: Mode.MENU,
                          selectedItem: controller[5].text,
                          items: slot,
                          label: "Slot",
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
                            title: title[0],
                            hint: "Enter ${title[0]}",
                            controller: controller[3],
                            maxLines: 1,
                            security: false,
                          ),
                        ),
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
                        MyTags(
                          sourceList: list,
                          selectedList: selectedList,
                          controller: controller[0],
                          hint: "Please select ${title[5]}",
                          title: title[5],
                        ),
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
          fromTo(txt: ctrl.text),
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
}
