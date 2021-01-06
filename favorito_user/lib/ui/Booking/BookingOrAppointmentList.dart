import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/ui/Booking/AppointmentChild.dart';
import 'package:favorito_user/ui/Booking/BookingChild.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/MyColors.dart';

class BookingOrAppointmentList extends StatefulWidget {
  String buId;
  BookingOrAppointmentList({this.buId});
  @override
  _BookingOrAppointmentListState createState() =>
      _BookingOrAppointmentListState();
}

class _BookingOrAppointmentListState extends State<BookingOrAppointmentList> {
  List<BookingOrAppointmentListModel> newDataList = [];
  List<BookingOrAppointmentListModel> historyDataList = [];
  List<BookingOrAppointmentListModel> inputDataList = [];
  String selectedTab = 'New';
  SizeManager sm;
  bool isAppointment;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: myBackGround,
            body: Padding(
              padding: EdgeInsets.all(sm.w(4)),
              child: Column(
                children: [
                  WaitListHeader(title: "Bookings/Appointments"),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                    width: sm.w(45),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => {setState(() => selectedTab = 'New')},
                            child: NewHistory('New'),
                          ),
                          InkWell(
                            onTap: () =>
                                {setState(() => selectedTab = 'History')},
                            child: NewHistory('History'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: isAppointment ? AppointmentChild() : BookingChild(),
                  )
                ],
              ),
            )));
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: sm.h(4),
        child: PopupContent(
          content: SafeArea(
            child: widget,
          ),
        ),
      ),
    );
  }

  Widget NewHistory(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 14.0, color: selectedTab == title ? myRed : myGrey)),
    );
  }
}
