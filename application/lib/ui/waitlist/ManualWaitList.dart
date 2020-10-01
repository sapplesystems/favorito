import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class ManualWaitList extends StatefulWidget {
  @override
  _ManualWaitListState createState() => _ManualWaitListState();
}

class _ManualWaitListState extends State<ManualWaitList> {
  List<bool> checked = [false, false, false];
  List<bool> radioChecked = [true, false, false];
  bool _autoValidateForm = false;
  List<String> lst = ["a", "b", "c"];
  List<TextEditingController> controller = [];
  List<String> list = ["pizza", "burger", "cold drink", "French fries"];
  List<String> selectedlist = [];
  List title = ["Title", "Price", "Discription", "Url", "Id"];
  SizeManager sm;
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) controller.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Manual WaitList",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        actions: [
          IconButton(
            icon: Icon(Icons.error_outline, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Container(
                decoration: bd1,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40.0),
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Column(children: [
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: sm.scaledHeight(1)),
                      child: txtfieldboundry(
                        valid: true,
                        title: title[i],
                        hint: "Enter ${title[i]}",
                        ctrl: controller[i],
                        maxLines: i == 2 ? 4 : 1,
                        security: false,
                      ),
                    ),
                ])),
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
}
