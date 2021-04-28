import 'package:Favorito/component/myTags.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/Category.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/menu/CallSwitcher.dart';
import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryForm extends StatefulWidget {
  String id;
  Category data;
  CategoryForm({this.id, this.data});
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  bool isFirst = true;
  List title = ['Details', 'Slot start time', 'Slot end time'];
  List<TextEditingController> controller = [];
  List<String> daylist = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  List<String> selectedDays = [];
  MaterialLocalizations localizations;
  SizeManager sm;
  Category da = Category();
  MenuProvider vaTrue;
  @override
  void initState() {
    print("category_id: ${widget.id}");
    print("category_id: ${widget.data}");
    super.initState();
    for (int i = 0; i < 4; i++) controller.add(TextEditingController());
    da = widget?.data;
    if (da != null) {
      controller[0].text = da?.details ?? '';
      controller[1].text = da?.slotStartTime ?? '';
      if (da?.availableOn != null)
        for (var _v in da?.availableOn?.split(',')) {
          if (_v != null && _v != "") {
            selectedDays.add(_v);
          }
        }
      for (var c in selectedDays) {
        daylist.remove(c ?? "");
      }
      controller[2].text = da?.slotEndTime ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      localizations = MaterialLocalizations.of(context);
      sm = SizeManager(context);
      vaTrue = Provider.of<MenuProvider>(context, listen: true);
      vaTrue.callerIdSet(int.parse(widget.id));
      isFirst = false;
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Edit Category',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    CallSwitcher(),
                    Text(
                      'Out of stock',
                      style: TextStyle(color: Colors.black, fontSize: 8),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(shrinkWrap: true, children: [
                for (int i = 0; i < title.length; i++)
                  InkWell(
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child,
                          );
                        },
                      ).then((value) {
                        setState(() {
                          if (i == 1) {
                            controller[i].text = localizations.formatTimeOfDay(
                                value,
                                alwaysUse24HourFormat: true);
                          } else if (i == 2) {
                            controller[i].text = localizations
                                .formatTimeOfDay(value,
                                    alwaysUse24HourFormat: true)
                                .substring(0, 5);
                          }
                        });
                      });
                    },
                    child: txtfieldboundry(
                      valid: true,
                      title: title[i],
                      maxLines: i == 0 ? 4 : 1,
                      hint: "Enter ${title[i]}",
                      controller: controller[i],
                      security: false,
                      isEnabled: i == 0 ? true : false,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTags(
                      sourceList: daylist,
                      selectedList: selectedDays,
                      hint: "Please select Sub category",
                      border: true,
                      directionVeticle: false,
                      title: " Selected Days "),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sm.w(14)),
                  child: RoundedButton(
                      clicker: () {
                        var avail = "";
                        if (selectedDays.length > 0)
                          for (var v in selectedDays) {
                            if (v != null && v != "") {
                              avail = v + "," + avail;
                              avail = avail.trim();
                            }
                          }
                        else
                          avail = "null";

                        avail.replaceAll(" ", ',');
                        Map _map = {
                          "id": widget.id,
                          "details": controller[0].text,
                          "slot_start_time": controller[1].text,
                          "slot_end_time": controller[2].text,
                          "available_on": avail?.trim()
                        };
                        print("Data:${_map.toString()}");
                        setData(_map);
                      },
                      clr: Colors.red,
                      title: 'Save'),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  setData(_map) async {
    print("Data:${_map.toString()}");
    await WebService.funMenuCatEdit(_map).then((value) {
      if (value.status == 'success') Navigator.pop(context);
    });
  }
}
