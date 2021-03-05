// import 'package:Favorito/model/waitlist/WaitlistListModel.dart';
// import 'package:Favorito/network/webservices.dart';
// import 'package:Favorito/ui/waitlist/Waitlist.dart';
// import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// class WaitListController {
//   Function function;
//   Waitlists wc;
//   BuildContext context;
//   WaitListController({this.function, this.context});

//   UpdateWaitList(String str, int id) async {
//     await WebService.funWaitlistUpdateStatus({"id": id, "status": str}, context)
//         .then((value) {
//       print(value.message);
//       if (value.status == "success") {
//         getPageData();
//       }
//     });
//   }

//   Future<WaitlistListModel> getPageData() async {
//     await WebService.funGetWaitlist(context).then((value) => value);
//   }
// }
