import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/Regexer.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ManualWaitList extends StatefulWidget {
  @override
  _ManualWaitListState createState() => _ManualWaitListState();
}

class _ManualWaitListState extends State<ManualWaitList> {
  ProgressDialog pr;
  List<TextEditingController> controller = [];
  List<String> selectedlist = [];
  GlobalKey<FormState> _frmKey = GlobalKey();
  List title = ["User Name", "Contact", "Number of Persons", "Special Notes"];
  List maxlens = [50, 10, 3, 200];
  SizeManager sm;
  bool validateForm = false;
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) controller.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal)
      ..style(
          message: 'Please wait...',
          borderRadius: 8.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 8.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
    sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Manual WaitList",
            // textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Gilroy-Bold',
                letterSpacing: 2)),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.error_outline, color: Colors.black),
          //   onPressed: () => Navigator.of(context).pop(),
          // )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // centerTitle: true,
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
                    autovalidate: validateForm,
                    child: Container(
                        decoration: bd1,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 40.0),
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(children: [
                          for (int i = 0; i < 4; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: sm.h(1)),
                              child: txtfieldboundry(
                                valid: true,
                                title: title[i],
                                myregex: i == 1 ? mobileRegex : null,
                                hint: "Enter ${title[i]}",
                                controller: controller[i],
                                keyboardSet: (i == 1 || i == 2)
                                    ? TextInputType.number
                                    : TextInputType.text,
                                maxlen: maxlens[i],
                                maxLines: i == 3 ? 4 : 1,
                                security: false,
                              ),
                            ),
                        ])),
                  )),
          Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(16), vertical: sm.h(2)),
              child: RoundedButton(
                  clicker: () {
                    if (_frmKey.currentState.validate())
                      funSublim();
                    else
                      setState(() => validateForm = true);
                  },
                  clr: Colors.red,
                  title: "Save"))
        ],
      ),
    );
  }

  void funSublim() {
    pr.show().timeout(Duration(seconds: 15));
    Map _map = {
      "name": controller[0].text,
      "contact": controller[1].text,
      "no_of_person": controller[2].text,
      "special_notes": controller[3].text
    };
    WebService.funCreateWaitlist(_map, context).then((value) {
      pr.hide();
      if (value.status == "success") {
        BotToast.showText(text: value.message);
        Navigator.pop(context);
      }
    });
  }
}
