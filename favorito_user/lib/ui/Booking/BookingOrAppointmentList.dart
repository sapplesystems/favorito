import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/Booking/AppBookProvider.dart';
import 'package:favorito_user/component/PopupContent.dart';
import 'package:favorito_user/component/PopupLayout.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/ui/Booking/BookAppChild.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../utils/Extentions.dart';

class BookingOrAppointmentParent extends StatelessWidget {
  SizeManager sm;
  bool isFirst = true;
  AppBookProvider vaTrue;
  AppBookProvider vaFalse;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<AppBookProvider>(context, listen: true);
    vaFalse = Provider.of<AppBookProvider>(context, listen: false);
    if (isFirst) {
      vaTrue.CallServiceForData(context);
      isFirst = false;
    }
    return WillPopScope(
      onWillPop: () => APIManager.onWillPop(context),
      child: Scaffold(
          key: RIKeys.josKeys22,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(vaTrue.getAppBookingHeader() ?? ""),
              actions: <Widget>[
                InkWell(
                    child: Icon(Icons.refresh),
                    onTap: () => vaTrue.CallServiceForData(context)),
                PopupMenuButton<String>(
                    onSelected: vaTrue.handleClick,
                    itemBuilder: (BuildContext context) {
                      return vaTrue.appBookingHeaderList
                          .map((String choice) => PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16))))
                          .toList();
                    })
              ]),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: sm.w(3)),
            child: BookAppChild(),
          )).safe(),
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
