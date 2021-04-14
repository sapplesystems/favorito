import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class JoinWaitList extends StatelessWidget {
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
        child: ListView(children: [
          WaitListHeader(
            title: 'Join Waitlist',
            preFunction: () => Navigator.of(context).pop(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                    'Slot Time : ${vaTrue.getWaitListData().availableTimeSlots}',
                    style:
                        TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 16)),
                Text('Duration : ${vaTrue.getWaitListData().slotLength}',
                    style:
                        TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 16)),
              ]),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Enter number of people',
                    style:
                        TextStyle(fontFamily: 'Gilroy-Regular', fontSize: 16)),
              ),
              counterAddRemove(),
              Padding(
                  padding: EdgeInsets.only(top: sm.h(3)),
                  child: EditTextComponent(
                      prefixIcon: 'name',
                      hint: 'Tag people by adding @',
                      controller: vaFalse.controller[1],
                      security: false,
                      valid: true,
                      maxLines: 1)),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: sm.h(3)),
                  child: EditTextComponent(
                      controller: vaFalse.controller[2],
                      hint: '          Special notes',
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
                    borderRadius: BorderRadius.all(Radius.circular(18.0))),
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
        ]),
      ),
    ));
  }

  counterAddRemove() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () => vaTrue.funAdd(false),
        child: Card(
          color: myBackGround,
          elevation: 12,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
              padding: EdgeInsets.all(sm.w(4)),
              child: Icon(Icons.remove, color: myRed)),
        ),
      ),
      Neumorphic(
        margin: EdgeInsets.symmetric(horizontal: sm.h(2)),
        style: NeumorphicStyle(
            depth: -10,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(28)),
            color: Colors.white60),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sm.w(10), vertical: sm.w(5)),
          child: Text(vaTrue.controller[0].text,
              style: TextStyle(color: Color(0xff686868)),
              textAlign: TextAlign.center),
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
