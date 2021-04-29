import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/model/booking/BookingModel.dart';
import 'package:Favorito/model/booking/SlotData.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/appoinment/AppoinmentProvider.dart';
import 'package:Favorito/ui/appoinment/appoinmentSetting.dart';
import 'package:Favorito/utils/dateformate.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../config/SizeManager.dart';
import 'package:url_launcher/url_launcher.dart';

class Appoinment extends StatelessWidget {
  AppoinmentProvider vaTrue;
  SizeManager sm;
  List<User> _userInputList = [];
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<AppoinmentProvider>(context,listen: true);
    if(isFirst){
    vaTrue.getAppointmentCall();
    isFirst = false;
    }
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            leading: null,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text("Appoinment", style: titleStyle),
            centerTitle: true,
            actions: [
              InkWell(
                child: Icon(Icons.add_circle_outline, size: 36),
                onTap: () {
                  print("abc1");

                  vaTrue.setSelectedAppointmentId(0);
                  Navigator.pushNamed(context,'/manualAppoinment').whenComplete(() =>
                    vaTrue.getAppointmentCall()
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                    alignment: Alignment.center),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppoinmentSetting()));
                },
              )
            ]),
        body:
        
            RefreshIndicator(
              onRefresh: ()async{
    vaTrue.getAppointmentCall();
              },
                          child: ListView(children: [
                InkWell(
                        onTap: () {

                    print("abc2");
                          showDatePicker(
                                  context: context,
                                  initialDate:
                                      vaTrue.getInitialDate() ?? DateTime.now(),
                                  firstDate:
                                      DateTime.now().subtract(Duration(days: 90)),
                                  lastDate: DateTime.now().add(Duration(days: 10)))
                              .then((_val) {
                            vaTrue.setInitialDate(dateFormat1.format(_val));
                          });
                        },
                        child: Container(
                            width: sm.w(20),
                            decoration: BoxDecoration(
                                border: Border.all(color: myGreyLight2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(
                                left: sm.w(36), right: sm.w(36), top: sm.w(6)),
                            padding: EdgeInsets.symmetric(vertical: sm.h(.8)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                      dateFormat1.format(vaTrue.getInitialDate()) ==
                                              dateFormat1.format(DateTime.now())
                                          ? 'Today'
                                          : dateFormat6.format(
                                                  vaTrue.getInitialDate()) ??
                                              'Select',
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center),
                                  SvgPicture.asset('assets/icon/triangle_down.svg')
                                ])),
                      ),
                       (vaTrue.getAppointmentData()?.slots?.length??0) == 0
            ? Center(child: Text('no any appointment'))
            : 
                  Container(
                    height: sm.h(30),
                        padding: EdgeInsets.only(top: 10),
                        margin: EdgeInsets.symmetric(horizontal: sm.w(4)),
                        child: GridView.builder(
                      itemCount: vaTrue.getAppointmentData()?.slots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: sm.w(3),
                          mainAxisSpacing: sm.h(0)),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () { 
                    print("abc3");
                            vaTrue.setSelectedSlotIndex(index);
                                vaTrue.setSelectedSlot(index);
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: vaTrue.getSelectedSlotIndex() == index
                                                ? myGrey
                                                : myRed,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0)),
                                  ),
                                  width: sm.w(10),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                            horizontal: 1.4, vertical: 8.0),
                                    child: Center(
                                      child: Text(
                                        "${vaTrue.getAppointmentData()?.slots[index]?.slotStart??'00:00'}-${vaTrue.getAppointmentData()?.slots[index]?.slotEnd??'00:00'}",
                                        style: TextStyle(
                                          color: Colors.white,
                                           fontFamily: 'Gilroy-Regular',
                                          backgroundColor:
                                                    vaTrue.getSelectedSlotIndex() ==
                                                            index
                                                        ? myGrey
                                                        : myRed
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: sm.w(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                          "${vaTrue.getAppointmentData()?.slots[index]?.slotData?.length ?? 0}",
                                          style: TextStyle(
                                              color: Colors.black,
                                                  fontFamily: 'Gilroy-Medium',
                                                  fontWeight: FontWeight.bold,
                                                  backgroundColor: Colors.white)),
                                    ),
                                  ),
                                ),
                              ]),
                        );
                      },
                    ),
                  ),
                  (vaTrue.getAppointmentData()?.slots?.length??0) == 0
            ? Center(child: Text(''))
            :  Container(
                     height: (vaTrue.getAppointmentData()?.slots?.length??0)  <2 ? sm.h(48) : null,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(34),
                            topRight: Radius.circular(34),
                          ),
                        ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            "User Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          height: sm.h(40),
                          child: ListView.builder(
                              itemCount: vaTrue.getAppointmentData()?.slots[vaTrue.getSelectedSlot()]?.slotData?.length??0,
                              itemBuilder: (BuildContext context, int _index) {
                                var va = vaTrue.getAppointmentData()?.slots[vaTrue.getSelectedSlot()]?.slotData[_index];

                                return Card(
                                  borderOnForeground: true,
                                  child: InkWell(
                                    onTap: () {

                    print("abc5");
                                      // showPopup(context, _popupBody(va));
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "${va.createdDate} | ${vaTrue.getAppointmentData()?.slots[vaTrue.getSelectedSlot()]?.slotStart} - ${vaTrue.getAppointmentData()?.slots[vaTrue.getSelectedSlot()]?.slotEnd}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              print("abc6");
                                              var _data = vaTrue.getAppointmentData()
                                                  .slots[vaTrue.getSelectedSlot()]
                                                  .slotData[_index];
                                              var _i = _index;
                                              vaTrue.setSelectedAppointmentId(_data.id);
                                              Navigator.pushNamed(context,'/manualAppoinment')
                                                    
                                                  .whenComplete(
                                                      () => vaTrue.getAppointmentCall());
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(right:10.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: myRed,
                                                size: 20
                                              ),
                                            ),
                                            
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            va.name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: AutoSizeText(
                                              va.specialNotes??"",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 12,
                                              maxFontSize: 14,
                                            ),
                                          ),
                                          trailing: InkWell(
                                            onTap: () =>
                                                launch("tel://${va.contact}"),
                                            child: Container(
                                              decoration: bd1Red,
                                              padding: EdgeInsets.all(6),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.call,
                                                color: Colors.white,
                                                size: 26,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ]),
            ),
              );
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
      context,
      PopupLayout(
        top: sm.h(30),
        left: sm.w(10),
        right: sm.w(10),
        bottom: sm.h(30),
        child: PopupContent(
          content: Scaffold(body: widget),
        ),
      ),
    );
  }

  Widget _popupBody(SlotData model) {
    return Container(child: null);
  }


}
