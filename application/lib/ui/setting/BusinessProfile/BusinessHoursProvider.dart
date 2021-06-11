// import 'package:Favorito/Provider/BaseProvider.dart';
// import 'package:Favorito/model/business/BusinessProfileModel.dart';
// import 'package:Favorito/network/webservices.dart';
// import 'package:Favorito/utils/myColors.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BusinessHoursProvider extends BaseProvider {
//   String _businessId;
//   SharedPreferences preferences;
//   String hoursTitle1 = 'Existing Slots';
//   String hoursTitle2 = 'Add New Slots';
//   List<Hours> daysHours = List();

//   bool _isEdit = false;
//   BuildContext context;

//   MaterialLocalizations localizations;

//   BoxDecoration bdcf = BoxDecoration(
//       border: Border.all(width: 1.0, color: myGrey),
//       borderRadius: BorderRadius.all(Radius.circular(5.0)));
//   BoxDecoration bdct = BoxDecoration(
//       color: myRed,
//       border: Border.all(width: 1.0, color: myRed),
//       borderRadius: BorderRadius.all(Radius.circular(5.0)));
//   BoxDecoration bdctt = BoxDecoration(
//       color: myGrey,
//       border: Border.all(width: 1.0, color: myRed),
//       borderRadius: BorderRadius.all(Radius.circular(5.0)));
//   String text;
//   List<String> daylist = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
//   Map<String, String> selecteddayList = {};
//   String startTime = 'Start Time';
//   String endTime = 'End Time';
//   List<int> renge = [];
//   // bool
//   BusinessHoursProvider() {
//     for (var _d in daylist) {
//       print("this is called 1");
//       daysHours.add(Hours(
//           day: _d, open: false, selected: false, startHours: "", endHours: ""));
//     }

//     getData();
//   }

//   setText(String _val) {
//     print("_val:$_val");
//     text = _val ?? "";
//     notifyListeners();
//     getData();
//   }

//   clear() {
//     text = '';
//     notifyListeners();
//   }

//   String getSelectedItem() => text;

//   getData() async {
//     await WebService.funGetBusinessWorkingHours().then((value) {
//       if (value.status == 'success') {
//         selecteddayList.clear();
//         for (int _i = 0; _i < value.data.length; _i++) {
//           selecteddayList[(value.data.toList())[_i].day] =
//               "${(value.data.toList())[_i].startHours}-${(value.data.toList())[_i].endHours}";
//           if ((value.data.toList())[_i].day.contains('-')) {
//             int _j = daylist
//                 .indexOf(((value.data.toList()[_i]).day).split('-')[0].trim());
//             int _k = daylist
//                 .indexOf(((value.data.toList()[_i]).day).split('-')[1].trim());
//             for (int _m = _j; _m <= _k; _m++) {
//               daysHours[_m].day = daylist[_m];
//               daysHours[_m].startHours = (value.data.toList())[_i].startHours;
//               daysHours[_m].endHours = (value.data.toList())[_i].endHours;
//               daysHours[_m].open = true;
//             }
//           } else {
//             int _a = daylist.indexOf((value.data.toList())[_i].day);

//             try {
//               daysHours[_a].day = daylist[_a];
//               daysHours[_a].startHours = (value.data.toList())[_i].startHours;
//               daysHours[_a].endHours = (value.data.toList())[_i].endHours;
//               daysHours[_a].open = true;
//             } catch (e) {
//               print("Error1:${e.toString()}");
//             }
//           }
//         }
//       }
//       notifyListeners();
//     });
//   }

//   SetContexts(BuildContext context) {
//     this.context = context;
//   }

//   popupClosed() {
//     renge.clear();
//     for (int i = 0; i < daysHours.length; i++) {
//       daysHours[i].selected = false;
//       daysHours[i].open = false;
//     }
//     startTime = 'Start Time';
//     endTime = 'End Time';
//     getData();
//     notifyListeners();
//   }

//   pickDate(val) {
//     showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (BuildContext context, Widget child) {
//         return MediaQuery(
//             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//             child: child);
//       },
//     ).then((value) {
//       var s = localizations
//           .formatTimeOfDay(value, alwaysUse24HourFormat: true)
//           .toString();
//       if (val)
//         startTime = s.substring(0, 5);
//       else
//         endTime = s.substring(0, 5);
//       notifyListeners();
//     });
//   }

//   setData(Map _map) async {
//     print("_map2:${_map.toString()}");
//     await WebService.funSetBusinessWorkingHours(_map).then((value) {
//       if (value.status == 'success') {
//         selecteddayList.clear();
//         for (int _i = 0; _i < value.data.length; _i++)
//           selecteddayList[(value.data.toList())[_i].day] =
//               "${(value.data.toList())[_i].startHours}-${(value.data.toList())[_i].endHours}";
//       }
//       daysHours.forEach((e) {
//         e.open = false;
//       });
//       getData();
//       Navigator.pop(context);
//     });
//   }

//   prepareData() {
//     if (startTime == 'Start Time' ||
//         endTime == 'End Time' ||
//         startTime.isEmpty ||
//         endTime.isEmpty) return;
//     List<Map<String, String>> h = [];

//     for (int i = 0; i < daysHours.length; i++) {
//       Map<String, String> m = Map();

//       m['business_days'] = daysHours[i].day;
//       if (_isEdit) {
//         if (daysHours[i].open) {
//           if (daysHours[i].selected) {
//             m['business_start_hours'] = startTime;
//             m['business_end_hours'] = endTime;
//           } else {
//             m['business_start_hours'] =
//                 daysHours[i].startHours.trim().substring(0, 5);
//             m['business_end_hours'] =
//                 daysHours[i].endHours.trim().substring(0, 5);
//           }
//           h.add(m);
//         }
//       } else {
//         if (daysHours[i].selected) {
//           m['business_start_hours'] = startTime;
//           m['business_end_hours'] = endTime;
//           h.add(m);
//         } else if (daysHours[i].open) {
//           m['business_start_hours'] = daysHours[i].startHours;
//           m['business_end_hours'] = daysHours[i].endHours;
//           h.add(m);
//         }
//       }
//     }
//     Map _map = {"business_hours": h};
//     print("_map1:${_map.toString()}");
//     setData(_map);
//   }

//   refresh() => notifyListeners();
//   setMod(_val) {
//     _isEdit = _val;
//     notifyListeners();
//   }

//   bool getMod() => _isEdit;

//   selectDay(int _index) {
//     print("$_isEdit $_index");
//     print("${daysHours[_index].open}");
//     print("${daysHours.toString()}");

//     if (_isEdit) {
//       if (renge.contains(_index) && daysHours[_index].open) {
//         daysHours[_index].selected = !daysHours[_index].selected;
//         if (!daysHours[_index].selected) {
//           print("doing off");
//           daysHours[_index].open = false;
//         }
//         startTime = daysHours[_index].startHours.trim().substring(0, 5);
//         endTime = daysHours[_index].endHours.trim().substring(0, 5);
//       } else {
//         daysHours[_index].selected = true;
//         daysHours[_index].startHours = startTime;
//         daysHours[_index].endHours = endTime;
//         daysHours[_index].open = true;
//       }
//     } else if (!_isEdit) {
//       if (!daysHours[_index].open) {
//         daysHours[_index].selected = !daysHours[_index].selected;
//       }
//     }
//     notifyListeners();
//   }

//   allClear() async {
//     preferences = await SharedPreferences.getInstance();
//     if (preferences.getString('businessId') != _businessId) {
//       _businessId = preferences.getString('businessId');
//       selecteddayList.clear();
//       notifyListeners();
//     }
//   }



// }
