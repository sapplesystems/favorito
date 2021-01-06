import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/BookingOrAppointmentListModel.dart';
import 'package:favorito_user/ui/Booking/NewAppointment.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AppointmentChild extends StatefulWidget {
  @override
  _appointmentChildState createState() => _appointmentChildState();
}

class _appointmentChildState extends State<AppointmentChild> {
  SizeManager sm;
  BookingOrAppointmentListModel data = BookingOrAppointmentListModel();
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return InkWell(
      onTap: () {
        showPopup(context, NewAppointment(1, data), 'Appointment');
      },
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
                    'data.businessName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'data.serviceName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'data.servicePersonName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "{data.date} | {data.slot}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  Visibility(
                    // visible: data.isHistory,
                    child: Row(
                      children: [
                        Text(
                          "Rating :",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        // for (var i = 0; i < data?.noOfReview ?? 0; i++)
                        for (var i = 0; i < 10; i++) Icon(Icons.star),
                      ],
                    ),
                  ),
                  Visibility(
                    // visible:" data.isHistory",
                    child: SizedBox(
                      width: sm.w(70),
                      child: Text(
                        "Review : ${"data.review"}",
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
