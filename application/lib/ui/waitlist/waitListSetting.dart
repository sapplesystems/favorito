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
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(waitlistSetting, style: TextStyle(color: Colors.black)),
        ),
        body: Builder(
            builder: (context) => Form(
                  key: vaFalse.key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        Card(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: sm.h(4), horizontal: sm.w(8)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text("Start waitlist daily at",
                                          style: TextStyle(color: Colors.grey)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                              onTap: () => showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget child) {
                                                      return MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                alwaysUse24HourFormat:
                                                                    true),
                                                        child: child,
                                                      );
                                                    },
                                                  ).then((value) {
                                                    vaFalse.startTime = vaFalse
                                                        .localizations
                                                        .formatTimeOfDay(value,
                                                            alwaysUse24HourFormat:
                                                                true);
                                                  }),
                                              child: fromTo(
                                                  txt: vaFalse.startTime,
                                                  clr: myRed)),
                                          InkWell(
                                              onTap: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget child) {
                                                    return MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              alwaysUse24HourFormat:
                                                                  true),
                                                      child: child,
                                                    );
                                                  },
                                                ).then((value) {
                                                  vaFalse.endTime = vaFalse
                                                      .localizations
                                                      .formatTimeOfDay(value,
                                                          alwaysUse24HourFormat:
                                                              true);
                                                });
                                              },
                                              child: fromTo(
                                                  txt: vaFalse.endTime,
                                                  clr: myRed))
                                        ],
                                      ),
                                      plusMinus("Available resources",
                                          vaFalse.controller[0]),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(bottom: sm.h(2)),
                                        child: txtfieldboundry(
                                          valid: true,
                                          title: vaFalse.title[3],
                                          isEnabled: true,
                                          keyboardSet: TextInputType.number,
                                          hint: "Enter ${vaFalse.title[0]}",
                                          controller: vaFalse.controller[1],
                                          maxLines: 1,
                                          security: false,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownSearch<String>(
                                            key: vaTrue.slotKey,
                                            validator: (v) => v == ''
                                                ? "required field"
                                                : null,
                                            autoValidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            mode: Mode.MENU,
                                            selectedItem:
                                                vaTrue.controller[2].text,
                                            items: vaTrue.slot,
                                            label: "${vaTrue.title[4]}",
                                            hint:
                                                "Please Select ${vaTrue.title[4]}",
                                            showSearchBox: false,
                                            onChanged: (value) {
                                              vaFalse.controller[2].text =
                                                  value;
                                            }),
                                      ),
                                      plusMinus("Booking/Slot",
                                          vaFalse.controller[3]),
                                      plusMinus(
                                          "Booking/Day", vaFalse.controller[4]),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(bottom: sm.h(2)),
                                          child: txtfieldboundry(
                                              valid: true,
                                              title: vaFalse.title[0],
                                              hint: "Enter ${vaFalse.title[0]}",
                                              controller: vaFalse.controller[5],
                                              maxLines: 1,
                                              security: false)),
                                      Padding(
                                          padding:
                                              EdgeInsets.only(bottom: sm.h(2)),
                                          child: txtfieldboundry(
                                              valid: true,
                                              title: vaFalse.title[1],
                                              hint: "Enter ${vaFalse.title[0]}",
                                              controller: vaFalse.controller[6],
                                              maxLines: 4,
                                              security: false)),
                                      MyTags(
                                          sourceList: vaFalse.list,
                                          selectedList: vaFalse.selectedList,
                                          hint:
                                              "Please select ${vaFalse.title[5]}",
                                          border: true,
                                          directionVeticle: false,
                                          title: vaTrue.title[5])
                                    ]))),
                        Padding(
                            padding: EdgeInsets.only(
                                left: sm.w(5),
                                right: sm.w(11),
                                top: sm.w(16),
                                bottom: sm.w(16)),
                            child: RoundedButton(
                                clicker: () {
                                  if (vaFalse.key.currentState.validate())
                                    vaFalse.submitDataCall();
                                },
                                clr: Colors.red,
                                title: "Done"))
                      ],
                    ),
                  ),
                )));
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
              ctrl.text = a.toString();
              vaTrue.notifyListeners();
            },
          ),
          fromTo(txt: ctrl.text, clr: myRed),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
            onPressed: () {
              ctrl.text = (int.parse(ctrl.text) + 1).toString();

              vaTrue.notifyListeners();
            },
          )
        ]),
      )
    ]);
  }
}
