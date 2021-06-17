// import 'package:Favorito/component/showPopup.dart';
// import 'package:Favorito/component/workingDateTime.dart';
// import 'package:Favorito/config/SizeManager.dart';
// import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
// import 'package:Favorito/utils/myColors.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BusinessHours extends StatelessWidget {
//   SizeManager sm;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(0),
//         child:
//             Consumer<BusinessProfileProvider>(builder: (context, data, child) {
//           return Column(children: [
//             Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: DropdownSearch<String>(
//                     validator: (_v) => _v == "" ? 'required field' : null,
//                     autoValidateMode: AutovalidateMode.onUserInteraction,
//                     mode: Mode.MENU,
//                     showSelectedItem: true,
//                     selectedItem: data.text ?? '',
//                     items: ["Select Hours", "Always Open"],
//                     label: "Working Hours",
//                     hint: "Please Select",
//                     showSearchBox: false,
//                     maxHeight: 110,
//                     onChanged: (value) {
//                       data.setText(value != null ? value : "");
//                       Provider.of<BusinessProfileProvider>(context,
//                               listen: false)
//                           .needSave(true);
//                     })),
//             Visibility(
//               visible: data.text == "Select Hours",
//               child: Padding(
//                 padding: EdgeInsets.only(left: 18, right: 18),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Business Hours",
//                               style: TextStyle(color: myGrey)),
//                           Visibility(
//                             visible: false,
//                             // visible: bspFalse.getSelectedItem() == "Select Hours",

//                             child: InkWell(
//                               onTap: () {
//                                 // bspTrue.selecteddayList.clear(),
//                                 data.getData();
//                               },
//                               child: Text("Refresh slot \u27F3",
//                                   style: TextStyle(color: Colors.red)),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(vertical: sm.w(1)),
//                               width: sm.w(60),
//                               height: sm.w(14),
//                               child: ListView(
//                                 scrollDirection: Axis.horizontal,
//                                 children: [
//                                   for (int i = 0;
//                                       i < data.selecteddayList.length;
//                                       i++)
//                                     InkWell(
//                                       onTap: () {
//                                         data.setMod(true);
//                                         if (((data.selecteddayList.keys
//                                                 .toList())[i])
//                                             .contains('-')) {
//                                           print("range is called");
//                                           int _a = data.daylist.indexOf((((data
//                                                   .selecteddayList.keys
//                                                   .toList())[i])
//                                               .split('-')[0]
//                                               .trim()));

//                                           int _b = data.daylist.indexOf((((data
//                                                   .selecteddayList.keys
//                                                   .toList())[i])
//                                               .split('-')[1]
//                                               .trim()));
//                                           print("$_a ab ");
//                                           for (int _i = _a; _i <= _b; _i++) {
//                                             data.renge.add(_i);
//                                             data.selectDay(_i);
//                                           }
//                                         } else {
//                                           print("single is called");

//                                           data.renge.add(data.daylist.indexOf(
//                                               data.selecteddayList.keys
//                                                   .toList()[i]));
//                                           data.selectDay(data.daylist.indexOf(
//                                               data.selecteddayList.keys
//                                                   .toList()[i]));
//                                         }
//                                         showPopup(
//                                                 ctx: context,
//                                                 widget: WorkingDateTime(),
//                                                 callback: () =>
//                                                     data.popupClosed(),
//                                                 sm: sm,
//                                                 sizesLeft: 3,
//                                                 sizesRight: 3,
//                                                 sizesTop: 24,
//                                                 sizesBottom: 44)
//                                             .show();
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 12),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                       data.selecteddayList.keys
//                                                           .toList()[i],
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight:
//                                                               FontWeight.w400)),
//                                                   SizedBox(height: 2),
//                                                   Text(
//                                                       "${(data.selecteddayList[data.selecteddayList.keys.toList()[i]].split("-")[0]).substring(0, 5)}-${(data.selecteddayList[data.selecteddayList.keys.toList()[i]].split("-")[1]).substring(0, 5)}",
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight:
//                                                               FontWeight.w200)),
//                                                 ])
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 data.setMod(false);
//                                 showPopup(
//                                         ctx: context,
//                                         widget: WorkingDateTime(),
//                                         callback: () => data.popupClosed(),
//                                         sm: sm,
//                                         sizesLeft: 3,
//                                         sizesRight: 3,
//                                         sizesTop: 24,
//                                         sizesBottom: 44)
//                                     .show();
//                               },
//                               child: Text("Add",
//                                   style: TextStyle(color: Colors.red)),
//                             )
//                           ])
//                     ]),
//               ),
//             ),
//           ]);
//         }));
//   }
// }
