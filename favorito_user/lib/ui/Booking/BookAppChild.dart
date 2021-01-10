import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentDataModel.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import '../../utils/myString.dart';
import '../../utils/Extentions.dart';

class BookAppChild extends StatefulWidget {
  BookingOrAppointmentDataModel data;
  BookAppChild({this.data});
  String selectedTab = 'New';
  @override
  _BookAppChildState createState() => _BookAppChildState();
}

class _BookAppChildState extends State<BookAppChild> {
  SizeManager sm;
  List<BookingOrAppointmentDataModel> data = List();
  List<BookingOrAppointmentDataModel> newData = List();
  List<BookingOrAppointmentDataModel> oldData = List();
  BookingOrAppointmentListModel source = BookingOrAppointmentListModel();
  Future<BookingOrAppointmentListModel> fut;

  bool serviceInProgress = false;

  @override
  void initState() {
    super.initState();
    fut = getrefreshedData();
  }

  Future<BookingOrAppointmentListModel> getrefreshedData() {
    return widget.data.isBooking == 0
        ? APIManager.baseUserBookingList(
            {"business_id": widget?.data?.businessId ?? null})
        : APIManager.baseUserAppointmentList(
            {"business_id": widget?.data?.businessId ?? null});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<BookingOrAppointmentListModel>(
        future: fut,
        builder: (BuildContext context,
            AsyncSnapshot<BookingOrAppointmentListModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text(loading));
          else {
            serviceInProgress = false;
            source.data = snapshot.data.data;
            newData.clear();
            oldData.clear();
            for (int _i = 0; _i < source.data.length; _i++) {
              DateTime.parse(source.data[_i].createdDatetime)
                      .isAfter(DateTime.now())
                  ? newData.add(source.data[_i])
                  : oldData.add(source.data[_i]);
            }
            data.clear();
            var _v = widget.selectedTab == 'New' ? newData : oldData;

            data.addAll(_v);
            print("dataSize:${data.length}:::${widget.selectedTab}");
            print("${widget.selectedTab}");
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  fut = getrefreshedData();
                });
              },
              child: Column(
                children: [
                  Container(
                    height: sm.h(10),
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
                            onTap: () => setState(() {
                              widget.selectedTab = 'New';
                            }),
                            child: NewHistory('New'),
                          ),
                          InkWell(
                            onTap: () => setState(() {
                              widget.selectedTab = 'History';
                            }),
                            child: NewHistory('History'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: sm.h(71),
                    child: data.length == 0
                        ? Center(child: Text(snapshot.data.message))
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => {
                                  // showPopup(context, NewAppointment(1, data), 'Appointment')
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: sm.h(1)),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(sm.w(4)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${data[index].businessName.capitalize()}  ',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'GilRoy-Bold'),
                                                      ),
                                                      Iconizer(
                                                          val: data[index]
                                                              .status)
                                                    ],
                                                  ),
                                                ),
                                                // Text(
                                                //   data.data[index].name,
                                                //   style: TextStyle(
                                                //       fontSize: 16,
                                                //       fontWeight: FontWeight.w400),
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Text(
                                                    DateFormat(
                                                            'dd MMMM yyyy | h:mm a')
                                                        .format(DateTime.parse(
                                                            data[index]
                                                                .createdDatetime)),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Visibility(
                                                    visible: data[index]
                                                            ?.specialNotes
                                                            ?.isNotEmpty ??
                                                        false,
                                                    child: Text(
                                                      "${data[index].specialNotes}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: Visibility(
                                                    visible: data[index]
                                                            ?.review
                                                            ?.isNotEmpty ??
                                                        false,
                                                    child: Text(
                                                      "Review : ${data[index].review}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                // Visibility(
                                                //   visible: "data.isHistory",
                                                //   child: Row(
                                                //     children: [
                                                //       Text(
                                                //         "Rating :",
                                                //         style: TextStyle(
                                                //             fontSize: 16,
                                                //             fontWeight: FontWeight.w400,
                                                //             color: Colors.grey),
                                                //       ),
                                                //       for (var i = 0; i < data.noOfReview ?? 0; i++)
                                                //         Icon(Icons.star),
                                                //     ],
                                                //   ),
                                                // ),
                                                // Visibility(
                                                //   visible: data.isHistory,
                                                //   child: SizedBox(
                                                //     width: sm.w(70),
                                                //     child: Text(
                                                //       "Review : ${data.review}",
                                                //       style: TextStyle(
                                                //           fontSize: 16,
                                                //           fontWeight: FontWeight.w400,
                                                //           color: Colors.grey),
                                                //       maxLines: 1,
                                                //       overflow: TextOverflow.ellipsis,
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                                onTap: () => launch(
                                                    "tel://${data[index].businessPhone}"),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: myRed,
                                                        border: Border.all(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
                                                    padding: EdgeInsets.all(6),
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(Icons.call,
                                                        color: Colors.white,
                                                        size: 20))),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            );
          }
        });
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

  NewHistory(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 14.0,
              color: widget.selectedTab == title ? myRed : myGrey)),
    );
  }
}

class Iconizer extends StatefulWidget {
  String val;
  Iconizer({this.val});
  @override
  _IconizerState createState() => _IconizerState();
}

class _IconizerState extends State<Iconizer> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    print("widget.val${widget.val}");
    sm = SizeManager(context);
    return Icon(
      widget.val == 'pending'
          ? Icons.hourglass_full
          : widget.val == 'accepted'
              ? Icons.check_circle
              : Icons.check_circle,
      color: myRed,
      size: sm.w(6),
    );
  }
}
