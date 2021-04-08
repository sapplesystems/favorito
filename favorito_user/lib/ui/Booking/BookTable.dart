import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/ui/Booking/AppBookProvider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BookTable extends StatelessWidget {
  SizeManager sm;
  AppBookProvider vaTrue;
  AppBookProvider vaFalse;
  var fut;
  int isFirst = 0;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<AppBookProvider>(context, listen: true);
    vaFalse = Provider.of<AppBookProvider>(context, listen: false);
    if (isFirst < 3) {
      fut = vaTrue.baseUserBookingVerbose();
      isFirst++;
    }
    return Scaffold(
      body: FutureBuilder(
        future: fut,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text("Please Wait"));
          else
            // Consumer<bool>(builder: (context, _data, child) {});
            return RefreshIndicator(
              onRefresh: () async {
                vaTrue.baseUserBookingVerbose();
              },
              child: SafeArea(
                child: Scaffold(
                  body: Consumer<AppBookProvider>(
                      builder: (context, _data, child) {
                    return Container(
                      decoration: BoxDecoration(color: myBackGround),
                      child: Column(children: [
                        Row(children: [
                          IconButton(
                              color: Colors.black,
                              iconSize: 45,
                              icon: Icon(Icons.keyboard_arrow_left),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          Text("Book Table", //bookTable change this
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))
                        ]),
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
                                      child: Row(
                                        children: [
                                          Text(_data.bookTableVerbose?.data
                                                  ?.businessName ??
                                              "")
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(top: sm.h(2)),
                                      child: counterAddRemove()),

                                  Divider(height: sm.h(6)),
                                  Text('Date', style: TextStyle(color: myGrey)),
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
                                      controller: vaTrue.controller[0],
                                      title: "Name",
                                      hint: "Enter Name",
                                      maxLines: 1,
                                      security: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: sm.h(4)),
                                    child: EditTextComponent(
                                      controller: vaTrue.controller[1],
                                      title: "Mobile",
                                      hint: "Enter Mobile",
                                      maxLines: 1,
                                      security: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: sm.h(4)),
                                    child: EditTextComponent(
                                      controller: vaTrue.controller[2],
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
                      ]),
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
            for (var temp in vaTrue.slotList)
              InkWell(
                onTap: () {
                  for (var temp in vaTrue.slotList) {
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
              value: vaTrue.selectedOccasion,

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
                        child: Text(value)));
              }).toList(),
              onChanged: (String value) {
                vaTrue.selectedOccasion = value;
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
        SvgPicture.asset('assets/icon/man_book_table.svg'),
        Container(
          margin: EdgeInsets.symmetric(horizontal: sm.w(4)),
          width: sm.w(22),
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: -10,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
                color: Colors.white60),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(4), vertical: sm.w(5)),
              child: Consumer<AppBookProvider>(builder: (context, data, child) {
                return Text('${vaTrue.getParticipent()}',
                    style: TextStyle(color: Color(0xff686868)),
                    textAlign: TextAlign.center);
              }),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: sm.w(8)),
          child: InkWell(
            onTap: () => vaTrue.changeParticipent(false),
            child: Card(
              color: myBackGround,
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: EdgeInsets.all(sm.w(4)),
                child: Icon(Icons.remove, color: myRed, size: 16),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => vaTrue.changeParticipent(true),
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
