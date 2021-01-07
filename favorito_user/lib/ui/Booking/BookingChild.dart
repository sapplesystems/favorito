import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointment/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/Booking/NewAppointment.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/myString.dart';

class BookingChild extends StatefulWidget {
  String id;
  BookingChild({this.id});
  @override
  _BookingChildState createState() => _BookingChildState();
}

class _BookingChildState extends State<BookingChild> {
  SizeManager sm;
  BookingOrAppointmentListModel data = BookingOrAppointmentListModel();
  Future fut;
  @override
  void initState() {
    super.initState();
    fut = APIManager.baseUserBookingList({"user_id": 3});
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
            data.data = snapshot.data.data;
            return ListView.builder(
                itemCount: data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => showPopup(
                        context, NewAppointment(1, data), 'Appointment'),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(sm.w(2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data[index].businessName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   data.data[index].name,
                                //   style: TextStyle(
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w400),
                                // ),
                                Text(
                                  "${data.data[index].createdDatetime.split(' ')[0]} | ${data.data[index].createdDatetime.split(' ')[1]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "${"data.noOfPerson"}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
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
                                SizedBox(
                                  width: sm.w(70),
                                  child: Text(
                                    "data.notes",
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
                              padding: EdgeInsets.only(right: sm.w(5)),
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
                });
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
}
