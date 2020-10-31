import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class BookingSetting extends StatefulWidget {
  @override
  _BookingSettingState createState() => _BookingSettingState();
}

class _BookingSettingState extends State<BookingSetting> {
  List<String> titleList =[""];
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
  List<TextEditingController> controller = [];

  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      controller.add(TextEditingController());
      controller[i].text = "0";
    }
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
                          for (int i = 0; i < 2; i++)
                            plusMinus("Available resources", controller[i]),
                          DropdownSearch<String>(
                              validator: (v) =>
                                  v == '' ? "required field" : null,
                              autoValidate: true,
                              mode: Mode.MENU,
                              selectedItem: controller[2].text,
                              items: slot,
                              label: "Slot Length",
                              hint: "Please Select Slot",
                              showSearchBox: false,
                              onChanged: (value) {
                                setState(() => controller[3].text = value);
                              }),
                          for (int i = 3; i < 5; i++)
                            plusMinus("Available resources", controller[i]),
                          Padding(
                            padding: EdgeInsets.only(bottom: 0),
                            child: txtfieldboundry(
                              valid: true,
                              title: "announcement",
                              maxLines: 4,
                              hint: "Enter announcement",
                              controller: controller[4],
                              security: false,
                            ),
                          )
                        ]))),
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
          padding: EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                icon: Icon(Icons.remove_circle_outline, color: myRed, size: 28),
                onPressed: () {
                  int a = int.parse(ctrl.text);
                  a = a > 0 ? a - 1 : a;
                  setState(() => ctrl.text = a.toString());
                }),
            fromTo(txt: ctrl.text, clr: myRed),
            IconButton(
                icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
                onPressed: () => setState(
                    () => ctrl.text = (int.parse(ctrl.text) + 1).toString()))
          ]))
    ]);
  }
}
