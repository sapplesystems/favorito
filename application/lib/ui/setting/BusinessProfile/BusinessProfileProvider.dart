// import 'package:flutter/material.dart';

// class BusinessProfileProvider extends ChangeNotifier {
//   Map<String, String> selecteddayList = {};
//   BusinessProfileProvider() {}

//   businessHoursBallancer(Map<String, String> selecteddayList) {
//     List ls = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

//     List<Abc> list = [];
//     List<Abc> list2 = [];
//     List<Abc> list3 = [];
//     for (int i = 0; i < selecteddayList.length; i++) {
//       Abc abc = Abc();
//       abc.id = i;
//       abc.txt = selecteddayList.keys.toList()[i];
//       abc.start =
//           (selecteddayList[selecteddayList.keys.toList()[i]]).substring(0, 5);
//       abc.end =
//           (selecteddayList[selecteddayList.keys.toList()[i]]).substring(8, 13);
//       abc.val = 0;
//       list.add(abc);
//     }
//     for (int _i = 0; _i < ls.length; _i++) {
//       for (int _j = 0; _j < list.length; _j++) {
//         if (ls[_i] == list[_j].txt) {
//           list3.add(list[_j]);
//         }
//       }
//     }
//     Map<String, String> _temp = {};
//     list2.clear();
//     for (int _i = 0; _i < list3.length; _i++) {
//       list2.add(list3[_i]);
//       bool a = false;
//       for (int _j = _i + 1; _j < list3.length; _j++) {
//         if ((list3[_j - 1].start == list3[_j].start) &&
//             (list3[_j - 1].end == list3[_j].end)) {
//           a = true;
//           ++_i;
//         } else {
//           print("list:${list[_i].txt}");
//           print("list:${list[_i].start} - ${list[_i].end}");
//           list2.last.txt = list2.last.txt + (a ? (" - " + list3[_i].txt) : "");
//           _j = list3.length;

//           // break;
//         }
//       }
//     }
//     for (var v in list2) {
//       print("list2:${v.txt}");
//       print("list2:${v.start} - ${v.end}");
//     }
//     selecteddayList.clear();
//     for (var v in list2) {
//       selecteddayList[v.txt] = "${v.start}-${v.end}";
//     }
//     notifyListeners();
//     // return selecteddayList;
//   }
// }
