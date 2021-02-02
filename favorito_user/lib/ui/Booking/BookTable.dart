import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/Providers/BookTableProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookTableVerbose.dart';
import 'package:favorito_user/model/appModel/SlotListModel.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class BookTable extends StatelessWidget {
  var _myUserNameEditTextController = TextEditingController();
  // var _noOfPeopleEditTextController = TextEditingController();
  var _myMobileEditTextController = TextEditingController();
  var _myNotesEditTextController = TextEditingController();
  List<TextEditingController> controller = [
    TextEditingController(),
    TextEditingController()
  ];

  SizeManager sm;
  String _selectedOccasion;

  String _selectedDateText;

  DateTime _initialDate;

  List<SlotListModel> slotList = [];

  var appBookProviderTrue;
  var appBookProviderFalse;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    appBookProviderTrue = Provider.of<AppBookProvider>(context, listen: true);
    appBookProviderFalse = Provider.of<AppBookProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: appBookProviderTrue.baseUserBookingVerbose(),
        builder:
            (BuildContext context, AsyncSnapshot<BookTableVerbose> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Text("Please Wait"),
            );
          else if (snapshot.hasError)
            return Center(
              child: Text('SomeThing went wrong'),
            );
          else
            Consumer<AppBookProvider>(builder: (context, _data, child) {});
          return RefreshIndicator(
            onRefresh: () async {
              appBookProviderTrue.baseUserBookingVerbose();
            },
            child: SafeArea(
              child: Scaffold(
                body:
                    Consumer<AppBookProvider>(builder: (context, _data, child) {
                  return Container(
                    decoration: BoxDecoration(color: myBackGround),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                color: Colors.black,
                                iconSize: 45,
                                icon: Icon(Icons.keyboard_arrow_left),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            Text(
                              "Book Table", //bookTable change this
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: sm.w(8)),
                              decoration: BoxDecoration(color: myBackGround),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Center(
                                    child: Text(
                                      _data.bookTableVerbose?.data
                                              ?.businessName ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: sm.h(2)),
                                      child: counterAddRemove()),

                                  Padding(
                                      padding: EdgeInsets.only(top: sm.h(2)),
                                      child: Row(
                                        children: [
                                          Text(_data.bookTableVerbose?.data
                                                  ?.businessName ??
                                              "")
                                        ],
                                      )),
                                  // Padding(
                                  //   padding: EdgeInsets.only(top: sm.h(3)),
                                  //   child: Center(
                                  //     child: DatePicker(
                                  //       selectedDateText: _selectedDateText,
                                  //       selectedDate: _initialDate,
                                  //       onChanged: ((value) {
                                  //         _selectedDateText = value;
                                  //       }),
                                  //     ),
                                  //   ),
                                  // ),
                                  mySlotSelector(),
                                  myOccasionDropDown(),
                                  Padding(
                                    padding: EdgeInsets.only(top: sm.h(4)),
                                    child: EditTextComponent(
                                      ctrl: _myUserNameEditTextController,
                                      title: "Name",
                                      hint: "Enter Name",
                                      maxLines: 1,
                                      security: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: sm.h(4)),
                                    child: EditTextComponent(
                                      ctrl: _myMobileEditTextController,
                                      title: "Mobile",
                                      hint: "Enter Mobile",
                                      maxLines: 1,
                                      security: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: sm.h(4)),
                                    child: EditTextComponent(
                                      ctrl: _myNotesEditTextController,
                                      title: "Special Notes",
                                      hint: "Enter Special Notes",
                                      maxLines: 4,
                                      security: false,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: sm.h(4), bottom: sm.h(2)),
                            child: NeumorphicButton(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.convex,
                                  depth: 4,
                                  lightSource: LightSource.topLeft,
                                  color: myButtonBackground,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.all(Radius.circular(24.0)))),
                              margin:
                                  EdgeInsets.symmetric(horizontal: sm.w(10)),
                              onPressed: () {
                                BotToast.showText(text: "Appointment sheduled");
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Center(
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: myRed),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget mySlotSelector() {
    return Padding(
      padding: EdgeInsets.only(top: sm.h(2)),
      child: Container(
        width: sm.w(100),
        height: sm.h(10),
        decoration: BoxDecoration(color: Colors.transparent),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (var temp in slotList)
              InkWell(
                onTap: () {
                  for (var temp in slotList) {
                    temp.selected = false;
                  }
                  temp.selected = true;
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      right: sm.w(1), top: sm.h(2), bottom: sm.h(2)),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        depth: 8,
                        lightSource: LightSource.top,
                        color: Colors.white,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.all(Radius.circular(8.0)))),
                    margin: EdgeInsets.symmetric(horizontal: sm.w(2)),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
                        child: Text(temp.slot,
                            style: TextStyle(
                                color: temp.selected
                                    ? Colors.green
                                    : Colors.grey)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget myOccasionDropDown() {
    return Padding(
      padding: EdgeInsets.only(top: sm.h(2)),
      child: Center(
        child: SizedBox(
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                depth: 8,
                lightSource: LightSource.top,
                color: Colors.white,
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.all(Radius.circular(8.0)))),
            margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedOccasion,

              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                child: Text("Select Occasion"),
              ),
              underline: Container(), // this is the magic
              items: <String>[
                'Occasion 1',
                'Occasion 2',
                'Occasion 3',
                'Occasion 4'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (String value) {
                _selectedOccasion = value;
              },
            ),
          ),
        ),
      ),
    );
  }

  counterAddRemove() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person_outline,
          size: 60,
          color: Colors.grey,
        ),
        Container(
          margin: EdgeInsets.only(right: sm.w(16)),
          width: sm.w(22),
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: -10,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(28)),
                color: Colors.white60),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(4), vertical: sm.w(5)),
              child: Consumer<AppBookProvider>(
                builder: (context, data, child) {
                  return Text(
                    '${appBookProviderTrue.getParticipent()}',
                    style: TextStyle(color: Color(0xff686868)),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => appBookProviderTrue.changeParticipent(false),
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
                size: 16,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => appBookProviderTrue.changeParticipent(true),
          child: Card(
            color: myBackGround,
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(sm.w(4)),
              child: Icon(
                Icons.add,
                color: myRed,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
