import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/waitlist/WaitlistProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:provider/provider.dart';

class WaitListSetting extends StatelessWidget {
  SizeManager sm;
  WaitlistProvider vaTrue;
  WaitlistProvider vaFalse;
  bool b = true;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<WaitlistProvider>(context, listen: true);
    vaFalse = Provider.of<WaitlistProvider>(context, listen: false);
    vaTrue.setContext(context);

    if (b) vaFalse.getPageData(context);
    b = false;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(waitlistSetting,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontFamily: 'Gilroy-Bold',
                  letterSpacing: .2)),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            vaTrue.getPageData(context);
          },
          child: Builder(
              builder: (context) => Form(
                    key: vaFalse.key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView(children: [
                        Card(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: sm.h(4), horizontal: sm.w(8)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Start waitlist daily at",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.grey)),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () =>
                                                vaTrue.dateTimePicker(true),
                                            child: fromTo(
                                                txt: vaFalse.startTime,
                                                clr: myRed,
                                                txtClr: Colors.black)),
                                        InkWell(
                                            onTap: () =>
                                                vaTrue.dateTimePicker(false),
                                            child: fromTo(
                                                txt: vaFalse.endTime,
                                                clr: myRed,
                                                txtClr: Colors.black))
                                      ]),
                                ),
                                plusMinus("Available resources",0),
                                Padding(
                                    padding: EdgeInsets.only(bottom: sm.h(2)),
                                    child: txtfieldboundry(
                                        valid: true,
                                        title: vaFalse.title[3],
                                        isEnabled: true,
                                        myOnChanged: (n) {},
                                        keyboardSet: TextInputType.number,
                                        hint: "Enter ${vaFalse.title[3]}",
                                        controller: vaFalse.controller[1],
                                        maxLines: 1,
                                        security: false)),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownSearch<String>(
                                      key: vaTrue.slotKey,
                                      validator: (v) =>
                                          v == '' ? "required field" : null,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      enabled: true,
                                      mode: Mode.MENU,
                                      // selectedItem:
                                      //     vaTrue.controller[2].text,
                                      items: vaTrue.slot,
                                      label: "${vaTrue.title[4]}",
                                      hint: "Please Select ${vaTrue.title[4]}",
                                      showSearchBox: false,
                                      onChanged: (value) {
                                        vaTrue.needSave(true);
                                        vaTrue.controller[2].text = value;
                                      }),
                                ),
                                plusMinus(
                                    "Bookings/Slot", 3),
                                plusMinus(
                                    "Bookings/Day", 4),
                                Padding(
                                    padding: EdgeInsets.only(bottom: sm.h(2)),
                                    child: txtfieldboundry(
                                        valid: true,
                                        title: vaFalse.title[0],
                                        hint: "Enter ${vaFalse.title[0]}",
                                        controller: vaFalse.controller[5],
                                        maxLines: 1,
                                        security: false)),
                                Padding(
                                    padding: EdgeInsets.only(bottom: sm.h(2)),
                                    child: txtfieldboundry(
                                        valid: true,
                                        title: vaFalse.title[1],
                                        hint: "Enter ${vaFalse.title[1]}",
                                        controller: vaFalse.controller[6],
                                        maxLines: 4,
                                        myOnChanged: (n) {
                                          vaTrue.needSave(true);
                                        },
                                        security: false)),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: sm.h(1)),
                                  child: MyTags(
                                      searchable: false,
                                      sourceList: vaTrue?.list,
                                      selectedList: vaTrue?.getSelectedList(),
                                      hint: "Please select ${vaFalse.title[5]}",
                                      border: true,
                                      refresh: () {
                                        vaTrue.needSave(true);
                                      },
                                      directionVeticle: false,
                                      title: vaTrue.title[5]),
                                )
                              ]),
                        )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: sm.w(5),
                                right: sm.w(11),
                                top: sm.w(16),
                                bottom: sm.w(16)),
                            child: RoundedButton(
                                clicker: () {
                                  if (vaTrue.key.currentState.validate())
                                    vaTrue.submitDataCall();
                                },
                                clr: Colors.red,
                                title: "Done"))
                      ]),
                    ),
                  )),
        ));
  }

  Widget plusMinus(String _title,int controllerId) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("\n$_title", style: TextStyle(color: Colors.grey)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: myRed, size: 28),
            onPressed: () =>vaTrue.plusMinusMinus(controllerId)),
          fromTo(txt: vaTrue.controller[controllerId].text, clr: myRed, txtClr: Colors.black),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
            onPressed: ()=> vaTrue.plusMinusAdd(controllerId),
          )
        ]),
      )
    ]);
  }
}
