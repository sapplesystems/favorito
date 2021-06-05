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
import '../../utils/Extentions.dart';

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
        print('BookingList Called');
        vaTrue.CallServiceForData(context);
      },
      child: Column(
        children: [
          SizedBox(
            width: sm.w(45),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () => vaTrue.setSelectedTab('New'),
                  child: newHistory('New', context),
                ),
                InkWell(
                  onTap: () => vaTrue.setSelectedTab('History'),
                  child: newHistory('History', context ),
                ),
              ]),
            ),
          ),
          Consumer<AppBookProvider>(
            builder: (context, _data, child) {
              var da = _data.getPageData();
              return Container(
                height: sm.h(73),
                child: da.length == 0
                    ? Center(
                        child: Text(
                        vaTrue.getMessage() ?? 'No Data ',
                        style: Theme.of(context).textTheme.headline6.copyWith(),
                      ))
                    : ListView.builder(
                        itemCount: da.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("name is :${da[index].businessName}");
                          return Padding(
                            padding: EdgeInsets.only(top: sm.h(1)),
                            child: InkWell(
                              onTap: () {
                                // Navigator.pushNamed(context, '/appBookDetail');
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
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
                                                    da[index]
                                                        ?.businessName
                                                        ?.toString()
                                                        ?.capitalize(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'GilRoy-Bold'),
                                                  ),
                                                  Text(
                                                      "\t\t(${da[index]?.status})",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'GilRoy-Medium')),
                                                  // Icon(
                                                  //   da[index].status ==
                                                  //           'pending'
                                                  //       ? Icons.hourglass_full
                                                  //       : da[index].status ==
                                                  //               'accepted'
                                                  //           ? Icons.check_circle
                                                  //           : Icons
                                                  //               .check_circle,
                                                  //   color: myRed,
                                                  //   size: sm.w(6),
                                                  // )
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                            // Visibility(
                                            //   visible: da[index]
                                            //       .name!=null,
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.only(
                                            //         top: 2.0),
                                            //     child: Text(
                                            //           da[index]
                                            //               .name,
                                            //       style: TextStyle(
                                            //           fontSize: 12,color:myGrey,
                                            //           fontWeight:
                                            //           FontWeight.w400),
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Visibility(
                                                visible: da[index]
                                                        ?.specialNotes
                                                        ?.isNotEmpty ??
                                                    false,
                                                child: Text(
                                                  "${da[index].specialNotes}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                          fontSize: 13,
                                                          color: myGrey,
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
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
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

  newHistory(String title, context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
      child: Text(title,
          style: Theme.of(context).textTheme.headline6.copyWith(
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
