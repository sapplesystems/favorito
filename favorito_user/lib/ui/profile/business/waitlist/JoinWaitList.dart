import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/profile/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class JoinWaitList extends StatelessWidget {
//   WaitListDataModel data;
//   JoinWaitList({this.data});
//   @override
//   _JoinWaitListState createState() => _JoinWaitListState();
// }
//
// class _JoinWaitListState extends State<JoinWaitList> {
  SizeManager sm;
  BusinessProfileProvider vaTrue;
  BusinessProfileProvider vaFalse;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BusinessProfileProvider>(context, listen: true);
    vaFalse = Provider.of<BusinessProfileProvider>(context, listen: false);
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
              child: Column(children: [
                counterAddRemove(),
                Padding(
                    padding: EdgeInsets.only(top: sm.h(3)),
                    child: EditTextComponent(
                        controller: vaFalse.controller[1],
                        title: 'Tag people by adding @',
                        security: false,
                        valid: true,
                        maxLines: 1)),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: sm.h(3)),
                    child: EditTextComponent(
                        controller: vaFalse.controller[2],
                        title: 'Special notes',
                        security: false,
                        valid: true,
                        maxLines: 8))
              ]),
            ),
            InkWell(
              onTap: () async {
                vaTrue.setWaitList(context);
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

  counterAddRemove() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          int i = int.parse(vaTrue.controller[0].text);
          vaTrue.controller[0].text = (i > 1 ? --i : i).toString() ?? '';
          // notify
        },
        child: Card(
          color: myBackGround,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
          padding:
              EdgeInsets.symmetric(horizontal: sm.w(10), vertical: sm.w(5)),
          child: Text(
            vaTrue.controller[0].text,
            style: TextStyle(color: Color(0xff686868)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      InkWell(
          onTap: () => vaTrue.funAdd(true),
          child: Card(
              color: myBackGround,
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Padding(
                  padding: EdgeInsets.all(sm.w(4)),
                  child: Icon(Icons.add, color: myRed))))
    ]);
  }
}
