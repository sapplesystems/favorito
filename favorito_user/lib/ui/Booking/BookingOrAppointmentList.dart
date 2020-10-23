import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/serviceModel/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/ui/Booking/BookTable.dart';
import 'package:favorito_user/ui/Booking/NewAppointment.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BookingOrAppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      usedTheme: UsedTheme.LIGHT,
      child: Material(
        child: NeumorphicBackground(
          child: _BookingOrAppointmentList(),
        ),
      ),
    );
  }
}

class _BookingOrAppointmentList extends StatefulWidget {
  @override
  _BookingOrAppointmentListState createState() =>
      _BookingOrAppointmentListState();
}

class _BookingOrAppointmentListState extends State<_BookingOrAppointmentList> {
  List<BookingOrAppointmentListModel> newDataList = [];
  List<BookingOrAppointmentListModel> historyDataList = [];
  List<BookingOrAppointmentListModel> inputDataList = [];
  String selectedTab = 'New';

  @override
  void initState() {
    setState(() {
      BookingOrAppointmentListModel model1 = BookingOrAppointmentListModel();
      model1.businessName = "Avadh Group";
      model1.date = "12 January";
      model1.slot = "13:00";
      model1.notes =
          "jhg gasf sgfs dfgs dfgskagf sdfgsakfgsdfgsekjf gsdjgsaeffgdgajesdj";
      model1.isAppointment = true;
      model1.serviceName = "Haircut";
      model1.servicePersonName = "Rohit";
      model1.noOfReview = 0;
      model1.review = "";
      model1.isHistory = false;
      newDataList.add(model1);

      BookingOrAppointmentListModel model2 = BookingOrAppointmentListModel();
      model2.businessName = "Avadh Group";
      model2.date = "12 January";
      model2.slot = "13:00";
      model2.notes =
          "jhg gasf sgfs dfgs dfgskagf sdfgsakfgsdfgsekjf gsdjgsaeffgdgajesdj";
      model2.isAppointment = false;
      model2.bookingName = "Gautam";
      model2.noOfPerson = "5";
      model2.noOfReview = 4;
      model2.review = "Very bad experience";
      model2.occasion = "Occasion 1";
      model2.mobile = "9999888877";
      model2.isHistory = true;
      historyDataList.add(model2);
      newDataList.add(model2);

      inputDataList.add(model1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(color: myBackGround),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        iconSize: 45,
                        color: Colors.black,
                        icon: Icon(Icons.keyboard_arrow_left),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Text(
                      "Bookings/Appointments",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(
                  width: sm.scaledWidth(45),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => {
                            setState(() {
                              selectedTab = 'New';
                              inputDataList.clear();
                              for (var temp in newDataList) {
                                BookingOrAppointmentListModel model =
                                    BookingOrAppointmentListModel();
                                model.businessName = temp.businessName;
                                model.serviceName = temp.serviceName;
                                model.servicePersonName =
                                    temp.servicePersonName;
                                model.date = temp.date;
                                model.slot = temp.slot;
                                model.notes = temp.notes;
                                model.noOfPerson = temp.noOfPerson;
                                model.bookingName = temp.bookingName;
                                model.isAppointment = temp.isAppointment;
                                model.noOfReview = temp.noOfReview;
                                model.review = temp.review;
                                model.isHistory = false;
                                model.occasion = temp.occasion;
                                model.mobile = temp.mobile;
                                inputDataList.add(model);
                              }
                            })
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("New",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: selectedTab == 'New'
                                        ? Colors.grey
                                        : null)),
                          ),
                        ),
                        Text("|"),
                        InkWell(
                          onTap: () => {
                            setState(() {
                              selectedTab = 'History';
                              inputDataList.clear();
                              for (var temp in historyDataList) {
                                BookingOrAppointmentListModel model =
                                    BookingOrAppointmentListModel();
                                model.businessName = temp.businessName;
                                model.serviceName = temp.serviceName;
                                model.servicePersonName =
                                    temp.servicePersonName;
                                model.date = temp.date;
                                model.slot = temp.slot;
                                model.notes = temp.notes;
                                model.noOfPerson = temp.noOfPerson;
                                model.bookingName = temp.bookingName;
                                model.isAppointment = temp.isAppointment;
                                model.noOfReview = temp.noOfReview;
                                model.review = temp.review;
                                model.isHistory = true;
                                model.occasion = temp.occasion;
                                inputDataList.add(model);
                                model.mobile = temp.mobile;
                              }
                            })
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "History",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: selectedTab == 'History'
                                      ? Colors.grey
                                      : null),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: sm.scaledWidth(100),
                  padding: EdgeInsets.symmetric(
                      horizontal: sm.scaledWidth(4),
                      vertical: sm.scaledHeight(2)),
                  decoration: BoxDecoration(color: myBackGround),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (var temp in inputDataList)
                        temp.isAppointment
                            ? appointmentChild(sm, temp)
                            : bookingChild(sm, temp)
                    ],
                  ),
                )
              ],
            )));
  }

  Widget bookingChild(SizeManager sm, BookingOrAppointmentListModel data) {
    return InkWell(
      onTap: () {
        showPopup(sm, context, _popupBodyBooking(sm, data), 'Appointment');
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(sm.scaledWidth(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.businessName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.bookingName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${data.date} | ${data.slot}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${data.noOfPerson}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Visibility(
                    visible: data.isHistory,
                    child: Row(
                      children: [
                        Text(
                          "Rating :",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        for (var i = 0; i < data.noOfReview ?? 0; i++)
                          Icon(Icons.star),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: data.isHistory,
                    child: SizedBox(
                      width: sm.scaledWidth(70),
                      child: Text(
                        "Review : ${data.review}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sm.scaledWidth(70),
                    child: Text(
                      data.notes,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: sm.scaledWidth(5)),
                child: Icon(
                  Icons.call,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentChild(SizeManager sm, BookingOrAppointmentListModel data) {
    return InkWell(
      onTap: () {
        showPopup(sm, context, _popupBodyAppointment(sm, data), 'Appointment');
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(sm.scaledWidth(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.businessName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.serviceName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    data.servicePersonName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "${data.date} | ${data.slot}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Visibility(
                    visible: data.isHistory,
                    child: Row(
                      children: [
                        Text(
                          "Rating :",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        for (var i = 0; i < data.noOfReview ?? 0; i++)
                          Icon(Icons.star),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: data.isHistory,
                    child: SizedBox(
                      width: sm.scaledWidth(70),
                      child: Text(
                        "Review : ${data.review}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sm.scaledWidth(70),
                    child: Text(
                      data.notes,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: sm.scaledWidth(5)),
                child: Icon(
                  Icons.call,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showPopup(SizeManager sm, BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(4),
        child: PopupContent(
          content: SafeArea(
            child: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBodyAppointment(
      SizeManager sm, BookingOrAppointmentListModel data) {
    return NewAppointment(1, data);
  }

  Widget _popupBodyBooking(SizeManager sm, BookingOrAppointmentListModel data) {
    return BookTable(1, data);
  }
}
