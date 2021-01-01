import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/route_manager.dart';
import 'package:progress_dialog/progress_dialog.dart';

class JoinWaitList extends StatefulWidget {
  WaitListDataModel data;
  JoinWaitList({this.data});
  @override
  _JoinWaitListState createState() => _JoinWaitListState();
}

class _JoinWaitListState extends State<JoinWaitList> {
  List<TextEditingController> controller = [];
  SizeManager sm;

  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      controller.add(TextEditingController());
    }
    controller[0].text = '1';
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Fetching Data, please wait');
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xfff9faff),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            WaitListHeader(title: 'Join Waitlist'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            int i = int.parse(controller[0].text);
                            controller[0].text = (i > 1 ? --i : i).toString();
                          });
                        },
                        child: Card(
                          color: myBackGround,
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(sm.w(4)),
                            child: Icon(
                              Icons.remove,
                              color: myRed,
                            ),
                          ),
                        ),
                      ),
                      Neumorphic(
                        margin: EdgeInsets.symmetric(horizontal: sm.h(2)),
                        style: NeumorphicStyle(
                            depth: -10,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(28),
                            ),
                            color: Colors.white60),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: sm.w(10), vertical: sm.w(5)),
                          child: Text(
                            controller[0].text,
                            style: TextStyle(color: Color(0xff686868)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            int i = int.parse(controller[0].text);
                            controller[0].text = (++i).toString();
                          });
                        },
                        child: Card(
                          color: myBackGround,
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(sm.w(4)),
                            child: Icon(
                              Icons.add,
                              color: myRed,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: sm.h(3)),
                    child: EditTextComponent(
                      ctrl: controller[1],
                      title: 'Tag people by adding @',
                      security: false,
                      valid: true,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.h(3)),
                    child: EditTextComponent(
                      ctrl: controller[2],
                      title: 'Special notes',
                      security: false,
                      valid: true,
                      maxLines: 8,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                if (!pr.isShowing()) pr.show();
                Map _map = {
                  'no_of_person': controller[0].text,
                  'name': controller[1].text,
                  'special_notes': controller[2].text,
                  'business_id': widget.data.businessId
                };
                await APIManager.baseUserWaitlistSet(_map).then((value) async {
                  if (pr.isShowing()) pr.hide();
                  if (value.status == 'success') {
                    await widget.data.fun1();
                    Navigator.pop(context);
                  }
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.w(24)),
                child: Card(
                  color: myBackGround,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sm.w(12), vertical: sm.w(4)),
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: myRed,
                          fontFamily: 'Gilroy-Reguler',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
