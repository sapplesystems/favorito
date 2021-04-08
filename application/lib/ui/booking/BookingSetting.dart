import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingSetting extends StatelessWidget {
  SizeManager sm;
  BookingProvider vaTrue;
  BookingProvider vaFalse;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BookingProvider>(context, listen: true);
    vaFalse = Provider.of<BookingProvider>(context, listen: false);

    if (isFirst) {
      vaTrue.getPageData();
      isFirst = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffff4f4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(bookingSetting, style: titleStyle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          vaTrue.getPageData();
        },
        child: Builder(
          builder: (context) => Form(
            key: RIKeys.josKeys5,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
              child: ListView(children: [
                Card(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sm.h(4), horizontal: sm.w(8)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Start booking daily at",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.grey)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                          onTap: () =>
                                              vaTrue.dateTimePicker(true),
                                          child: fromTo(
                                              txt: vaTrue.getStartTime(),
                                              clr: myRed,
                                              txtClr: Colors.black)),
                                      InkWell(
                                          onTap: () =>
                                              vaTrue.dateTimePicker(false),
                                          child: fromTo(
                                              txt: vaTrue.getEndTime(),
                                              clr: myRed,
                                              txtClr: Colors.black))
                                    ]),
                              ),
                              for (int i = 0; i < 2; i++)
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text("\n${vaTrue.title[i]}",
                                          style: TextStyle(color: Colors.grey)),
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: myRed,
                                                        size: 28),
                                                    onPressed: () =>
                                                        vaTrue.subTraction(i)),
                                                fromTo(
                                                    txt: vaTrue
                                                        .controller[i].text,
                                                    clr: myRed),
                                                IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        size: 28,
                                                        color: myRed),
                                                    onPressed: () =>
                                                        vaTrue.addition(i))
                                              ]))
                                    ]),
                              DropdownSearch<String>(
                                  key: RIKeys.josKeys3,
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  mode: Mode.MENU,
                                  selectedItem: vaTrue.controller[2].text,
                                  items: vaTrue.slot,
                                  label: vaTrue.title[2],
                                  hint: "Please Select Slot",
                                  showSearchBox: false,
                                  onChanged: (value) {
                                    vaTrue
                                      ..controller[2].text = value
                                      ..setDone(true);
                                  }),
                              for (int i = 3; i < 5; i++)
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text("\n${vaTrue.title[i]}",
                                          style: TextStyle(color: Colors.grey)),
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: myRed,
                                                        size: 28),
                                                    onPressed: () =>
                                                        vaTrue.subTraction(i)),
                                                fromTo(
                                                    txt: vaTrue
                                                        .controller[i].text,
                                                    clr: myRed),
                                                IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        size: 28,
                                                        color: myRed),
                                                    onPressed: () =>
                                                        vaTrue.addition(i))
                                              ]))
                                    ]),
                              Padding(
                                padding: EdgeInsets.only(bottom: 0),
                                child: txtfieldboundry(
                                  valid: true,
                                  title: vaTrue.title[5] ?? "",
                                  maxLines: 4,
                                  hint: "Enter announcement",
                                  controller: vaTrue.controller[5],
                                  security: false,
                                  myOnChanged: (_) {
                                    vaTrue.setDone(true);
                                  },
                                ),
                              )
                            ]))),
                Visibility(
                  visible: vaTrue.getDone(),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(16), vertical: sm.h(2)),
                      child: vaTrue.getIsProgress()
                          ? Center(child: CircularProgressIndicator())
                          : RoundedButton(
                              clicker: () {
                                if (RIKeys.josKeys5.currentState.validate())
                                  vaTrue.funSublim();
                              },
                              clr: Colors.red,
                              title: "Done")),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
