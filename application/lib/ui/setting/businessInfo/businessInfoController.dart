// import 'package:Favorito/network/webservices.dart';
// import 'package:flutter/material.dart';

// class businessInfoController  {
//   var count = 0.obs;
//   var catid;
//   var cat = "".obs;

//   List<TextEditingController> controller = [];
//   businessInfoController() {
//     for (int i = 0; i < 6; i++) controller.add(TextEditingController());
//   }
//   var loadedImageList = [];
//   increment() => count++;

//   void gePageData() {
//     WebService.getBusinessInfoData().then((value) {
//       if (value.message == "success") {
//         var va = value.data;
//         loadedImageList = va.photos;
//         cat = va.categoryName as RxString;
//         print("");
//         catid = va.categoryId;
//         loadedImageList = va.photos;
//         loadedImageList = va.photos;
//       }
//       print("aaaaaaa${value.toString()}");
//     });
//   }
// }
