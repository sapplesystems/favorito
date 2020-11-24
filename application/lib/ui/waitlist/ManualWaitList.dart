import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

class ManualWaitList extends StatefulWidget {
  @override
  _ManualWaitListState createState() => _ManualWaitListState();
}

class _ManualWaitListState extends State<ManualWaitList> {
  List<TextEditingController> controller = [];
  List<String> selectedlist = [];
  GlobalKey<FormState> _frmKey = GlobalKey();
  List title = ["User Name", "Contact", "Number of Persons", "Special Notes"];
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
      body: ListView(
        children: [
          Builder(
              builder: (context) => Form(
                    key: _frmKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                        decoration: bd1,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40.0),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(children: [
                          for (int i = 0; i < 4; i++)
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: sm.scaledHeight(1)),
                              child: txtfieldboundry(
                                valid: true,
                                title: title[i],
                                hint: "Enter ${title[i]}",
                                controller: controller[i],
                                keyboardSet: (i == 1 || i == 2)
                                    ? TextInputType.number
                                    : TextInputType.text,
                                maxlen: i == 1 ? 10 : 50,
                                maxLines: i == 3 ? 4 : 1,
                                security: false,
                              ),
                            ),
                        ])),
                  )),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sm.scaledWidth(16), vertical: sm.scaledHeight(2)),
              child: roundedButton(
                  clicker: () {
                    if (_frmKey.currentState.validate()) funSublim();
                  },
                  clr: Colors.red,
                  title: "Done"))
        ],
      ),
    );
  }

  void funSublim() {
    Map _map = {
      "name": controller[0].text,
      "contact": controller[1].text,
      "no_of_person": controller[2].text,
      "special_notes": controller[3].text
    };
    WebService.funCreateWaitlist(_map).then((value) {
      if (value.status == "success") {
        BotToast.showText(text: value.message);
        Navigator.pop(context);
      }
    });
  }
}
