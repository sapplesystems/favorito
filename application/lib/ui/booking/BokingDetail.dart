import 'package:Favorito/model/booking/BookingModel.dart';
import 'package:Favorito/model/waitlist/WaitlistModel.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/config/SizeManager.dart';

import '../../config/SizeManager.dart';

class BookingDetail extends StatefulWidget {
  User userModel;
  BookingDetail({this.userModel});

  @override
  _BookingDetail createState() => _BookingDetail();
}

class _BookingDetail extends State<BookingDetail> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    ));
  }
}
