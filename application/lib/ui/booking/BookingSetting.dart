import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingSetting extends StatelessWidget {
  SizeManager sm;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
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
        body: Consumer<BookingProvider>(
          builder: (context, data, child) {
            if (isFirst) {
              sm = SizeManager(context);
              data.getPageData();
              isFirst = false;
            }
            return RefreshIndicator(
              onRefresh: () async {
                data
                  ..getPageData()
                  ..getRestrinction(context);
              },
              child: Builder(
                builder: (context) => Form(
                  key: RIKeys.josKeys5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
                    child: ListView(children: [
                      Card(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: sm.h(4), horizontal: sm.w(8)),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Start booking daily at",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.grey)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () =>
                                                    data.dateTimePicker(true),
                                                child: fromTo(
                                                    txt: data.getStartTime() ??
                                                        '00:00',
                                                    clr: myRed,
                                                    txtClr: Colors.black)),
                                            InkWell(
                                                onTap: () =>
                                                    data.dateTimePicker(false),
                                                child: fromTo(
                                                    txt: data.getEndTime() ??
                                                        '00:00',
                                                    clr: myRed,
                                                    txtClr: Colors.black))
                                          ]),
                                    ),
                                    for (int i = 0; i < 2; i++)
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text("\n${data.title[i]}",
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                            Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline,
                                                              color: myRed,
                                                              size: 28),
                                                          onPressed: () => data
                                                              .subTraction(i)),
                                                      fromTo(
                                                          txt: data
                                                              .controller[i]
                                                              .text,
                                                          clr: myRed),
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .add_circle_outline,
                                                              size: 28,
                                                              color: myRed),
                                                          onPressed: () =>
                                                              data.addition(i))
                                                    ]))
                                          ]),
                                    DropdownSearch<String>(
                                        key: RIKeys.josKeys3,
                                        validator: (v) =>
                                            v == '' ? "required field" : null,
                                        autoValidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        mode: Mode.MENU,
                                        selectedItem: data.controller[2].text,
                                        items: data.slot,
                                        label: data.title[2],
                                        enabled: false,
                                        hint: "Please Select Slot",
                                        showSearchBox: false,
                                        onChanged: (value) {
                                          data
                                            ..controller[2].text = value
                                            ..setDone(true);
                                        }),
                                    for (int i = 3; i < 5; i++)
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text("\n${data.title[i]}",
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                            Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline,
                                                              color: myRed,
                                                              size: 28),
                                                          onPressed: () => data
                                                              .subTraction(i)),
                                                      fromTo(
                                                          txt: data
                                                              .controller[i]
                                                              .text,
                                                          clr: myRed),
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .add_circle_outline,
                                                              size: 28,
                                                              color: myRed),
                                                          onPressed: () =>
                                                              data.addition(i))
                                                    ]))
                                          ]),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 0),
                                      child: txtfieldboundry(
                                        valid: true,
                                        title: data.title[5] ?? "",
                                        maxLines: 4,
                                        hint: "Enter announcement",
                                        controller: data.controller[5],
                                        security: false,
                                        myOnChanged: (_) {
                                          data.setDone(true);
                                        },
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: null),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Restriction',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: myGrey,
                                                  fontSize: 14),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            data.controller[6].text = "";
                                            data.controller[7].text = "";
                                            Navigator.pushNamed(context,
                                                '/bookigDateRistriction');
                                          },
                                          child: Text(
                                            'Add New',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: myRed,
                                                    fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(children: [
                                      for (int i = 0;
                                          i < data.restrictionDataList.length;
                                          i++)
                                        Column(
                                          children: [
                                            Divider(),
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(data.restrictionDataList[i].endDate ==
                                                          ""
                                                      ? dateFormat5.format(
                                                          DateTime.parse(data
                                                              .restrictionDataList[
                                                                  i]
                                                              .startDate))
                                                      : dateFormat5.format(
                                                              DateTime.parse(data
                                                                  .restrictionDataList[
                                                                      i]
                                                                  .startDate)) +
                                                          " - " +
                                                          dateFormat5.format(
                                                              DateTime.parse(data.restrictionDataList[i].endDate))),
                                                  InkWell(
                                                      child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: myRed),
                                                      onTap: () {
                                                        showModalBottomSheet<
                                                                void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                height: 100,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      '\t\t\t\t\tAre you sure you want to delete ?',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Gilroy-Medium'),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        TextButton(
                                                                            child:
                                                                                Text("Ok", style: TextStyle(color: myRed, fontSize: 16, fontFamily: 'Gilroy-Medium')),
                                                                            onPressed: () async {
                                                                              data.funSublimRestriction(context, data.restrictionDataList[i].dateIds, true);
                                                                              Navigator.pop(context);
                                                                            }),
                                                                        InkWell(
                                                                          child:
                                                                              Text(
                                                                            "Cancel",
                                                                            style: TextStyle(
                                                                                color: myRed,
                                                                                fontSize: 16,
                                                                                fontFamily: 'Gilroy-Medium'),
                                                                          ),
                                                                          onTap: () =>
                                                                              Navigator.pop(context),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            });
                                                      })
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                    ])
                                  ]))),
                      Visibility(
                        // visible: vaTrue.getDone(),
                        visible: true,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: sm.w(16), vertical: sm.h(2)),
                            child: data.getIsProgress()
                                ? Center(child: CircularProgressIndicator())
                                : RoundedButton(
                                    clicker: () {
                                      if (RIKeys.josKeys5.currentState
                                          .validate()) data.funSublim();
                                    },
                                    clr: Colors.red,
                                    title: "Done")),
                      )
                    ]),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
