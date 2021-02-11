import 'package:Favorito/component/showPopup.dart';
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
                  selectedItem: bspFalse.controller.text,
                  items: ["Select Hours", "Always Open"],
                  label: "Working Hours",
                  hint: "Please Select",
                  showSearchBox: false,
                  maxHeight: 110,
                  onChanged: (value) {
                    bspFalse.controller.text = value != null ? value : "";
                    bspFalse.notifyListeners();
                  })),
          Visibility(
            visible: bspFalse.controller.text == "Select Hours",
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
                        onTap: () {
                          // bspTrue.selecteddayList.clear(),
                          bspTrue.getData();
                        },
                        child: Text("Refresh slot \u27F3",
                            style: TextStyle(color: Colors.red)),
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
                                onTap: () {
                                  bspTrue.setMod(true);
                                  if (((bspTrue.selecteddayList.keys
                                          .toList())[i])
                                      .contains('-')) {
                                    print("range is called");
                                    int _a = bspTrue.daylist.indexOf((((bspTrue
                                            .selecteddayList.keys
                                            .toList())[i])
                                        .split('-')[0]
                                        .trim()));

                                    int _b = bspTrue.daylist.indexOf((((bspTrue
                                            .selecteddayList.keys
                                            .toList())[i])
                                        .split('-')[1]
                                        .trim()));
                                    print("$_a ab ");
                                    for (int _i = _a; _i <= _b; _i++) {
                                      bspTrue.renge.add(_i);
                                      bspTrue.selectDay(_i);
                                    }
                                  } else {
                                    print("single is called");

                                    bspTrue.renge.add(bspTrue.daylist.indexOf(
                                        bspTrue.selecteddayList.keys
                                            .toList()[i]));
                                    bspTrue.selectDay(bspTrue.daylist.indexOf(
                                        bspTrue.selecteddayList.keys
                                            .toList()[i]));
                                  }
                                  showPopup(
                                          ctx: context,
                                          widget: WorkingDateTime(),
                                          callback: () => bspTrue.popupClosed(),
                                          sm: sm)
                                      .show();
                                },
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
                                                "${(bspTrue.selecteddayList[bspTrue.selecteddayList.keys.toList()[i]].split("-")[0]).substring(0, 5)}-${(bspTrue.selecteddayList[bspTrue.selecteddayList.keys.toList()[i]].split("-")[1]).substring(0, 5)}",
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
                          bspTrue.setMod(false);
                          showPopup(
                                  ctx: context,
                                  widget: WorkingDateTime(),
                                  callback: () => bspTrue.popupClosed(),
                                  sm: sm)
                              .show();
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
}
