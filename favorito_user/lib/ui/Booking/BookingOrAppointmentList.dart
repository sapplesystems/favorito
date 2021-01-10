import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/ui/Booking/BookAppChild.dart';
import 'package:favorito_user/ui/profile/business/waitlist/WaitListHeader.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/MyColors.dart';
import '../../utils/Extentions.dart';

class BookingOrAppointmentParent extends StatefulWidget {
  BookingOrAppointmentDataModel data;
  BookingOrAppointmentParent({this.data});
  @override
  _BookingOrAppointmentListState createState() =>
      _BookingOrAppointmentListState();
}

class _BookingOrAppointmentListState extends State<BookingOrAppointmentParent> {
  SizeManager sm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    return Scaffold(
        backgroundColor: myBackGround,
        body: Padding(
          padding: EdgeInsets.only(top: sm.w(1), left: sm.w(3), right: sm.w(3)),
          child: Column(
            children: [
              WaitListHeader(
                title: widget.data.isBooking == 0
                    ? 'Bookings'
                    : widget.data.isBooking == 1
                        ? "Appointments"
                        : "Bookings & Appointments",
                preFunction: () {
                  if (widget.data.isBooking != 2) Navigator.pop(context);
                },
              ),
              Container(child: BookAppChild(data: widget.data))
            ],
          ),
        )).safe();
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
}
