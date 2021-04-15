
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/SlotListModel.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BookAppointment extends StatelessWidget {

  var _myNotesEditTextController = TextEditingController();
  bool isFirst = true;
  String _selectedService;
  String _selectedServicePerson;

  String _selectedDateText = '';

  DateTime _initialDate;

  List<SlotListModel> slotList = [];



  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    if (isFirst) {
    }
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: myBackGround),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(children: [
              IconButton(
                  iconSize: 45,
                  color: Colors.black,
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              Text(
                "Appointment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ]),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: sm.w(8)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: Text(
                        'data.businessName',
                        style: TextStyle(
                            fontSize: 18, decoration: TextDecoration.underline),
                      ),
                    ),
                    myServiceDropDown(sm),
                    myServicePersonDropDown(sm),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: sm.h(3)),
                      child: Center(
                          child: Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.convex,
                          depth: 18,
                          lightSource: LightSource.top,
                          color: Colors.white,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.all(Radius.circular(10.0))),
                        ),
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sm.w(4)),
                            child: Text('selectedDateText',
                                style: TextStyle(
                                    fontSize: sm.h(2),
                                    color: Colors.grey[600]))),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      )),
                    ),
                    Padding(
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

                                  //setState();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: sm.w(1),
                                      top: sm.h(2),
                                      bottom: sm.h(2)),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.convex,
                                        depth: 8,
                                        lightSource: LightSource.top,
                                        color: Colors.white,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            BorderRadius.all(
                                                Radius.circular(8.0)))),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: sm.w(2)),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: sm.w(4)),
                                        child: Text(temp.slot,
                                            style: TextStyle(
                                                color: temp.selected
                                                    ? Colors.green
                                                    : Colors.grey,
                                                fontWeight: temp.selected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: sm.h(4)),
                      child: EditTextComponent(
                        controller: _myNotesEditTextController,
                        title: "Special Notes",
                        hint: "Enter Special Notes",
                        maxLines: 8,
                        security: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: sm.h(4), horizontal: sm.w(8)),
                      child:
                      // vaTrue.getSubmitCalled()?Center(
                      //   child: CircularProgressIndicator(
                      //       backgroundColor: myRed,
                      //       valueColor: AlwaysStoppedAnimation(myGrey),
                      //       strokeWidth: 4),
                      // ):
                      NeumorphicButton(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 4,
                            lightSource: LightSource.topLeft,
                            color: myBackGround,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(24.0)))),
                        margin: EdgeInsets.symmetric(horizontal: sm.w(10)),
                        onPressed: () {
                          // vaTrue.funSubmitBooking(context);

                        }
                          ,
                        padding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        child: Center(
                          child: Text("Done",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: myRed)),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ]),
        ),
      ),
    );
  }

  Widget myServiceDropDown(SizeManager sm) {
    return Padding(
      padding: EdgeInsets.only(top: sm.h(2)),
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
          value: _selectedService,
          isExpanded: true,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
            child: Text("Select Service"),
          ),
          underline: Container(),
          // this is the magic
          items: <String>[
            'Service 1',
            'Service 2',
            'Service 3',
            'Service 4',
            'Haircut'
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
            _selectedService = value;
            //setState();
          },
        ),
      ),
    );
  }

  Widget myServicePersonDropDown(SizeManager sm) {
    return Padding(
      padding: EdgeInsets.only(top: sm.h(2)),
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
          value: _selectedServicePerson,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
            child: Text("Select Service Person"),
          ),
          underline: Container(),
          // this is the magic
          items: <String>['Ramesh', 'Rohit', 'Mansij', 'Rohan', 'Gautam']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                child: Text(value),
              ),
            );
          }).toList(),
          onChanged: (String value) {
            _selectedServicePerson = value;
            // setState(() {
            // });
          },
        ),
      ),
    );
  }
}
