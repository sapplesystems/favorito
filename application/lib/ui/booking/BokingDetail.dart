import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/booking/SlotData.dart';
import 'package:Favorito/ui/booking/BookingProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/Extentions.dart';

class BokingDetail extends StatelessWidget {
  SlotData waitlistData;
  Function action;
  Function delete;
  String heading;
  bool isSmall;
  BokingDetail(
      {this.waitlistData,
      this.action,
      this.delete,
      this.heading,
      this.isSmall});

  BookingProvider vaTrue;
  BookingProvider vafalse;
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    vaTrue = Provider.of<BookingProvider>(context, listen: true);
    vafalse = Provider.of<BookingProvider>(context, listen: false);
    double i = (waitlistData?.specialNotes?.length??0) <= 500
        ? 10
        : (((waitlistData?.specialNotes?.length??0) > 500) &&
                ((waitlistData?.specialNotes?.length??0) <= 1000))
            ? 25
            : 40;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Scrollbar(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: sm.h(4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back)),
                    Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(heading,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey))),
                  ]),
                ]),
          ),
          Container(
              height: sm.h(6),
              padding: const EdgeInsets.all(4.0),
              child: Text("${waitlistData?.name?.capitalizeManner()}${waitlistData?.occasion!=null?' ('+waitlistData?.occasion?.capitalize()+')':""}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Gilroy-Regular',
                      fontWeight: FontWeight.w800))),
          // Container(
          //   height: sm.h(i),
          //   child: SingleChildScrollView(
          //     child:
          Expanded(
            child: SingleChildScrollView(
              // heightght: sm.h(40),
              child: Text(waitlistData?.specialNotes??'',
                  style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Gilroy-Regular',
                      fontWeight: FontWeight.w600)),
            ),
          ),
          //   ),
          // ),
          Container(
            height: sm.h(8),
            padding: const EdgeInsets.only(top: 1.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => _callPhone('tel:${waitlistData.contact}'),
                    child: CircleAvatar(
                      maxRadius: sm.h(3),
                      backgroundColor: myRed,
                      child:
                          Icon(Icons.call, size: sm.w(5), color: Colors.white),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () => action(false, waitlistData.id),
                  //   child: CircleAvatar(
                  //     maxRadius: sm.h(3),
                  //     backgroundColor: myRed,
                  //     child:
                  //         Icon(Icons.edit, size: sm.w(7), color: Colors.white),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      maxRadius: sm.h(3),
                      backgroundColor: myRed,
                      child: Icon(Icons.notifications_active_rounded,
                          size: sm.w(5), color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () {

                        showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 100,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                            '\t\t\t\t\tAre you sure you want to delete ?',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Gilroy-Medium'),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TextButton(
                                                                  child: Text(
                                                                      "Ok",
                                                                      style: TextStyle(
                                                                          color:
                                                                              myRed,
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'Gilroy-Medium')),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context); 
                                                                        delete(waitlistData.id);
                                                                        Navigator.pop(context);
                                                                  }),
                                                              InkWell(
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color:
                                                                          myRed,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Gilroy-Medium'),
                                                                ),
                                                                onTap: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            
                     
                    },
                    child: CircleAvatar(
                        maxRadius: sm.h(3),
                        backgroundColor: myRed,
                        child: Icon(Icons.close,
                            size: sm.w(7), color: Colors.white)),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }

  _callPhone(String phone) async {
    (await canLaunch(phone))
        ? await launch(phone)
        : throw 'Could not Call Phone';
  }
}
