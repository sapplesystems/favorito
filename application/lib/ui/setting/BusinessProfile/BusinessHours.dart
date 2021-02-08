import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/workingDateTime.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessHours extends StatelessWidget {
  GlobalKey dd1 = GlobalKey<DropdownSearchState<String>>();
  BusinessHours({this.dd1});
  BusinessHoursProvider bspTrue;
  BusinessHoursProvider bspFalse;
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    bspTrue = Provider.of<BusinessHoursProvider>(context, listen: true);
    bspFalse = Provider.of<BusinessHoursProvider>(context, listen: false);
    sm = SizeManager(context);
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: DropdownSearch<String>(
                  validator: (_v) => _v == "" ? 'required field' : null,
                  key: dd1,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  selectedItem: bspTrue.controller.text,
                  items: ["Select Hours", "Always Open"],
                  label: "Working Hours",
                  hint: "Please Select",
                  showSearchBox: false,
                  maxHeight: 110,
                  onChanged: (value) {
                    bspTrue.controller.text = value != null ? value : "";
                    bspTrue.notifyListeners();
                  })),
          Visibility(
            visible: bspTrue.controller.text == "Select Hours",
            child: Padding(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Business Hours", style: TextStyle(color: myGrey)),
                      InkWell(
                        onTap: () => bspTrue.selecteddayList.clear(),
                        onLongPress: () {},
                        child:
                            Text("Reset", style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: sm.w(1)),
                        width: sm.w(60),
                        height: sm.w(14),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 0;
                                i < bspTrue.selecteddayList.length;
                                i++)
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                bspTrue.selecteddayList.keys
                                                    .toList()[i],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            SizedBox(height: 2),
                                            Text(
                                                "${(bspTrue.selecteddayList[bspTrue.selecteddayList.keys.toList()[i]].split(" - ")[0]).substring(0, 5)} - ${(bspTrue.selecteddayList[bspTrue.selecteddayList.keys.toList()[i]].split("-")[1]).substring(0, 6)}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w200)),
                                          ])
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showPopup(
                              context,
                              WorkingDateTime(
                                  selecteddayList: bspTrue.selecteddayList));
                        },
                        child: Text("Add", style: TextStyle(color: Colors.red)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
// for (int i = 0; i < selecteddayList.length; i++) {
//       var va = selecteddayList[(selecteddayList.keys.toList())[i]].split("-");
//       Map<String, String> dayData = Map();
//       dayData["business_days"] =
//           "${(selecteddayList.keys.toList())[i].toString()}";
//       dayData["business_start_hours"] = "${va[0].toString()}";
//       dayData["business_end_hours"] = "${va[1].toString()}";
//       lst.add(dayData);
//     }
// for (int _i = 0; _i < va.hours.length; _i++)
//         selecteddayList[(va.hours.toList())[_i].day] =
//             "${(va.hours.toList())[_i].startHours}-${(va.hours.toList())[_i].endHours}";

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);

    Navigator.push(
            context,
            PopupLayout(
                top: sm.h(36),
                left: sm.w(3),
                right: sm.w(3),
                bottom: sm.h(30),
                child: PopupContent(
                    content: Scaffold(
                        resizeToAvoidBottomPadding: false, body: widget))))
        .whenComplete(() {
      // setState(() {});
    });
  }
}
