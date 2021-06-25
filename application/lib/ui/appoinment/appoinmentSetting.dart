import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/appoinment/RestrictionOnlyModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/utils/RIKeys.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Favorito/component/fromTo.dart';

class AppoinmentSetting extends StatelessWidget {
  AppoinmentProvider vaTrue;
  MaterialLocalizations localizations;
  bool isFirst = true;
  SizeManager sm;

  List<String> selectedList = [];

  @override
  Widget build(BuildContext context) {
   
   sm = SizeManager(context);
    vaTrue = Provider.of<AppoinmentProvider>(context, listen: true);

    localizations = MaterialLocalizations.of(context);
    if(isFirst){
    vaTrue.refreshCall();
    isFirst = false;
    }
    return Scaffold(
      key:RIKeys.josKeys10,
        appBar: AppBar(
          backgroundColor: Color(0xfffff4f4),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop()),
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Appoinment Setting", style: titleStyle),
        ),
        body: RefreshIndicator(
          onRefresh: ()async{
            vaTrue.refreshCall();
          }, 
                  child: Builder(
            builder: (ctx) => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
              child: ListView(
                children: [
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
                                  padding: EdgeInsets.symmetric(horizontal: 22.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              vaTrue.dateTimePicker(true,localizations);
                                            },
                                               
                                            child: fromTo(  
                                                txt: vaTrue.getStartTime()??'00:00',
                                                clr: myRed,
                                                txtClr: Colors.black)),
                                        InkWell(
                                            onTap: () {

                                                vaTrue.dateTimePicker(false,localizations);
                                            },
                                            child: fromTo(
                                                txt: vaTrue.getEndTime()??'00:00',
                                                clr: myRed,
                                                txtClr: Colors.black))
                                      ]),
                                ),
                          plusMinus("Advance Booking(Day)", 9),
                          plusMinus("Advance Booking(Hours)",10),
                          DropdownSearch<String>(
                            validator: (v) => v == '' ? "required field" : null,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            mode: Mode.MENU,
                            key: RIKeys.josKeys11,
                            maxHeight: 200,
                            selectedItem: vaTrue.controller[11].text,
                            items: vaTrue.slot,
                            label: "Slot Length",
                            showSelectedItem: true,
                            enabled: false,
                            hint: "Please Select Slot",
                            showSearchBox: false,
                            popupItemBuilder: (context,_val,_selected)=>Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left:12.0),
                                  child: Text(_val,style: TextStyle(fontFamily: 'Gilroy-Regular',fontSize: 16,)),
                                ),
                                  Divider()
                              ]
                            ),
                            onChanged: (value) {
                              vaTrue
                              ..controller[11].text = value
                              ..setDone(true);
                            }),
                          plusMinus("Booking/Slot", 12),
                          plusMinus("Booking/Day", 13),
                          Padding(
                            padding: EdgeInsets.only(bottom: sm.h(2)),
                            child: txtfieldboundry(
                                valid: true,
                                title: 'Anouncement',
                                hint: "Enter Anouncement",
                                controller: vaTrue.controller[14],
                                maxLines: 4,
                                myOnChanged: (_){
                                  vaTrue.setDone(true);
                                },
                                security: false),
                          ),
                          Column(children: [
                            addNewLabel("Services", labelClicked),
                            Divider(color: myGrey, height: 20),
                            if (vaTrue.getServicesList() != null)
                              for (int i = 0;
                                  i < vaTrue.getServicesList()?.length;
                                  i++)
                                my_ServiceSwitch(
                                    datalist: vaTrue.getServicesList(),
                                    i: i,
                                    function: vaTrue.changeit,
                                    identity: "s"),
                          ]),
                          Column(
                            children: [
                              addNewLabel("Person", labelClicked),
                              Divider(color: myGrey, height: 2),
                              if (vaTrue.getPerson() != null)
                                for (int i = 0;
                                    i < vaTrue.getPerson()?.length;
                                    i++)
                                  my_ServiceSwitch(
                                    datalist: vaTrue.getPerson(),
                                    i: i,
                                    function: vaTrue.changeit,
                                    identity: "p",
                                  ),
                            ],
                          ),
                          Divider(color: myGrey, height: 2),
                          if (vaTrue.getRestrictionList() != null)
                            additionalFunctionRistrict(
                                "Restrictions", vaTrue.getRestrictionList()),
                        ]),
                  )),
                 Visibility(
                   visible:  vaTrue.getDone(),
                                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(16), vertical: sm.h(2)),
                      child: RoundedButton(
                          clicker: () => vaTrue.funSettingSubmit(),
                          clr: Colors.red,
                          title: "Done"),
                    ),
                 )
                ]),
            ),
          ),
        ));
  }

  

  Widget fromToo(String txt) {
    return Container(
      margin: EdgeInsets.all(8),
      width: sm.w(24),
      height: sm.h(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: myRed,
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          txt,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget plusMinus(String _title,int controllerId) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("\n$_title", style: TextStyle(color: Colors.grey)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: myRed, size: 28),
            onPressed: () =>vaTrue.subTraction(controllerId),
          ),
          fromToo(vaTrue.controller[controllerId].text),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
            onPressed: () =>vaTrue.addition(controllerId),
            
          )
        ]),
      )
    ]);
  }

  addNewLabel(String s, labelClicked) {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: InkWell(
        onTap: () => labelClicked(s),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(s, style: geryTextSmall)),
          Text("Add New", style: redTextSmall),
        ]),
      ),
    );
  }

  int j;
  additionalFunctionRistrict(String title, List<RestrictionOnlyModel> data) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        addNewLabel(title, labelClicked),
        //for services
        Row(
          children: [Text("Services", style: TextStyle(fontSize: 16))],
        ),
        for (var _va in data)
          if (_va.serviceName != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_va.serviceName ?? ""),
                          Text(dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[0])) +
                              " - " +
                              dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[1])))
                        ]),
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            vaTrue.setSelectedRestrictionId(_va.id);
                            Navigator.pushNamed(RIKeys.josKeys10.currentContext, '/AddRestriction');
                          },
                          child: Text("Edit ", style: TextStyle(color: myRed))),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            vaTrue.deleteRestrictions(_va, RIKeys.josKeys10.currentContext);
                          },
                          child:
                              Text(" Delete", style: TextStyle(color: myRed)))
                    ],
                  )
                ],
              ),
            ),

        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sm.w(12), vertical: sm.w(4)),
          child: Divider(color: myGrey, height: 2),
        ), //for person
        Row(
          children: [Text("Appointment", style: TextStyle(fontSize: 16))],
        ),
        for (var _va in data)
          if (_va.personName != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_va.personName ?? ""),
                          Text(dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[0])) +
                              " - " +
                              dateFormat4.format(DateTime.parse(
                                  ((_va.dateTime ?? "").split(" - "))[1])))
                        ]),
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            print("asd1");
                            vaTrue.setSelectedRestrictionId(_va.id);

                            Navigator.pushNamed(RIKeys.josKeys10.currentContext, '/AddRestriction');
                          },
                          child: Text("Edit ", style: TextStyle(color: myRed))),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            vaTrue.deleteRestrictions(_va, RIKeys.josKeys10.currentContext);
                          },
                          child:
                              Text(" Delete", style: TextStyle(color: myRed)))
                    ],
                  )
                ],
              ),
            )
      ]),
    );
  }

  labelClicked(String _txt) async {
    switch (_txt) {
      case "Services":
        {
          print("asd2");
          Navigator.pushNamed(RIKeys.josKeys10.currentContext, '/addServices')
              .whenComplete(() => vaTrue.getPersonCall());
          break;
        }

      case "Person":
        {
          Navigator.pushNamed(RIKeys.josKeys10.currentContext, '/addPerson')
              .whenComplete(() => vaTrue.getPersonCall());
          // showPopup(context, _popupBody2(), top: 10, bottom: 10);
          break;
        }
      case "Restrictions":
        {
          vaTrue.setSelectedRestrictionId(0);
          Navigator.pushNamed(RIKeys.josKeys10.currentContext, '/AddRestriction')
              .whenComplete(() => vaTrue.getRestriction());
          break;
        }
    }
  }

  String selectedOption;
  // Widget _popupBody3(RestrictionOnlyModel _data) {

  //   return }

  showPopup(BuildContext context, Widget widget,
      {BuildContext popupContext,
      double left,
      double right,
      double top,
      double bottom}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
      context,
      PopupLayout(
        top: sm.h(top ?? 4),
        left: sm.w(left ?? 10),
        right: sm.w(right ?? 10),
        bottom: sm.h(bottom ?? 40),
        child: PopupContent(
          content: Scaffold(body: widget),
        ),
      ),
    );
  }

  void showBottom(Widget popupBody3) {
    showModalBottomSheet<void>(
        context: RIKeys.josKeys10.currentContext, builder: (BuildContext context) => popupBody3);
  }
}

class my_ServiceSwitch extends StatelessWidget {
  const my_ServiceSwitch({
    Key key,
    @required this.datalist,
    @required this.i,
    @required this.function,
    @required this.identity,
  }) : super(key: key);

  final List datalist;
  final int i;
  final Function function;
  final String identity;

  @override
  Widget build(BuildContext context) {
    print("datalist[i].isActive:${datalist[i].isActive}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //1 is active 0 is not active
        Text(
            identity == "s" ? datalist[i].serviceName : datalist[i].personName),
        Switch(
          onChanged: (val) => function(i, val, identity),
          value: datalist[i].isActive == 1,
          activeColor: myRed,
          activeTrackColor: myRedLight,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey,
        )
      ],
    );
  }
}
