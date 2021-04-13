import 'package:favorito_user/ui/Booking/AppBookProvider.dart';
import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import '../../utils/myString.dart';

class BookAppChild extends StatelessWidget {
  SizeManager sm;
  BookingOrAppointmentListModel source = BookingOrAppointmentListModel();

  AppBookProvider vaTrue;
  AppBookProvider vaFalse;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<AppBookProvider>(context, listen: true);
    vaFalse = Provider.of<AppBookProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        // vaTrue.getrefreshedData();
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                  visible: vaTrue.getCanAdd,
                  child: Icon(Icons.add_circle,
                      size: 30, color: Colors.transparent)),
              Container(
                height: sm.h(10),
                padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                width: sm.w(45),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => vaTrue.setSelectedTab('New'),
                          child: newHistory('New'),
                        ),
                        InkWell(
                          onTap: () => vaTrue.setSelectedTab('History'),
                          child: newHistory('History'),
                        ),
                      ]),
                ),
              ),
              Visibility(
                visible: vaTrue.getCanAdd,
                child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/bookTable'),
                  child: Icon(Icons.add_circle, size: 30, color: myRed),
                ),
              ),
            ],
          ),
          Consumer<AppBookProvider>(
            builder: (context, _data, child) {
              var da = _data.getPageData();
              return Container(
                height: sm.h(vaTrue.getIsBooking() == 2 ? 71 : 78),
                child: da.length == 0
                    ? Center(child: Text(vaTrue.getMessage() ?? 'No Data '))
                    : ListView.builder(
                        itemCount: da.length,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
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
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    da[index].businessName
                                                    // .capitalize()
                                                    ,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'GilRoy-Bold'),
                                                  ),
                                                  Icon(
                                                    da[index].status ==
                                                            'pending'
                                                        ? Icons.hourglass_full
                                                        : da[index].status ==
                                                                'accepted'
                                                            ? Icons.check_circle
                                                            : Icons
                                                                .check_circle,
                                                    color: myRed,
                                                    size: sm.w(6),
                                                  )
                                                  // Iconizer(
                                                  //     val: data
                                                  //         .getPageData()[index]
                                                  //         .status)
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text(
                                                DateFormat(
                                                        'dd MMMM yyyy | h:mm a')
                                                    .format(DateTime.parse(
                                                        da[index]
                                                            .createdDatetime)),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Visibility(
                                                visible: da[index]
                                                        ?.specialNotes
                                                        ?.isNotEmpty ??
                                                    false,
                                                child: Text(
                                                  "${da[index].specialNotes}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Visibility(
                                                visible: da[index]
                                                        ?.review
                                                        ?.isNotEmpty ??
                                                    false,
                                                child: Text(
                                                  "Review : ${da[index].review}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                            onTap: () => launch(
                                                "tel://${da[index].businessPhone}"),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: myRed,
                                                    border: Border.all(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                padding: EdgeInsets.all(6),
                                                margin:
                                                    EdgeInsets.only(right: 10),
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
              );
            },
          ),
        ],
      ),
    );
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

  newHistory(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Text(title,
          style: TextStyle(
              fontSize: 14.0,
              color: vaFalse.getSelectedTab() == title ? myRed : myGrey)),
    );
  }
}

// class Iconizer extends StatefulWidget {
//   String val;
//   Iconizer({this.val});
//   @override
//   _IconizerState createState() => _IconizerState();
// }

// class _IconizerState extends State<Iconizer> {
//   SizeManager sm;
//   @override
//   Widget build(BuildContext context) {
//     print("widget.val${widget.val}");
//     sm = SizeManager(context);
//     return Icon(
//       widget.val == 'pending'
//           ? Icons.hourglass_full
//           : widget.val == 'accepted'
//               ? Icons.check_circle
//               : Icons.check_circle,
//       color: myRed,
//       size: sm.w(6),
//     );
//   }
// }
