import 'package:Favorito/component/fromTo.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/booking/bookingSettingModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/utils/myString.Dart';

class BookingSetting extends StatefulWidget {
  @override
  _BookingSettingState createState() => _BookingSettingState();
}

class _BookingSettingState extends State<BookingSetting> {
  List<String> titleList = [""];
  List<String> slot = ["15", "20", "25", "30", "35", "40", "45", "50"];
  List<String> title = [
    "Advance Booking(Days)",
    "Advance Booking(Hours)",
    "Slot Length",
    "Booking/Slot",
    "Booking/Day",
    "Announcement"
  ];
  SizeManager sm;
  List<TextEditingController> controller = [];
  bookingSettingModel bs;
  GlobalKey<FormState> key = GlobalKey();
  void initState() {
    getPageData();
    super.initState();
    for (int i = 0; i < 6; i++) {
      controller.add(TextEditingController());
      controller[i].text = i != 5 ? "0" : "";
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      appBar: AppBar(
        backgroundColor: Color(0xfffff4f4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          bookingSetting,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Builder(
        builder: (context) => Form(
          key: key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4.0),
            child: ListView(
              children: [
                Card(
                    elevation: 8,
                    shape: rrb,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sm.scaledHeight(4),
                            horizontal: sm.scaledWidth(8)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int i = 0; i < 2; i++)
                                plusMinus(title[i], controller[i]),
                              DropdownSearch<String>(
                                  validator: (v) =>
                                      v == '' ? "required field" : null,
                                  autoValidateMode: AutovalidateMode.onUserInteraction,
                                  mode: Mode.MENU,
                                  selectedItem: controller[2].text,
                                  items: slot,
                                  label: title[2],
                                  hint: "Please Select Slot",
                                  showSearchBox: false,
                                  onChanged: (value) {
                                    setState(() => controller[2].text = value);
                                  }),
                              for (int i = 3; i < 5; i++)
                                plusMinus(title[i], controller[i]),
                              Padding(
                                padding: EdgeInsets.only(bottom: 0),
                                child: txtfieldboundry(
                                  valid: true,
                                  title: title[5],
                                  maxLines: 4,
                                  hint: "Enter announcement",
                                  controller: controller[5],
                                  security: false,
                                ),
                              )
                            ]))),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: sm.scaledWidth(16),
                        vertical: sm.scaledHeight(2)),
                    child: roundedButton(
                        clicker: () {
                          if (key.currentState.validate()) {
                            funSublim();
                          }
                        },
                        clr: Colors.red,
                        title: "Done"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget plusMinus(String _title, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text("\n$_title", style: TextStyle(color: Colors.grey)),
      Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                icon: Icon(Icons.remove_circle_outline, color: myRed, size: 28),
                onPressed: () {
                  int a = int.parse(ctrl.text);
                  a = a > 0 ? a - 1 : a;
                  setState(() => ctrl.text = a.toString());
                }),
            fromTo(txt: ctrl.text, clr: myRed),
            IconButton(
                icon: Icon(Icons.add_circle_outline, size: 28, color: myRed),
                onPressed: () => setState(
                    () => ctrl.text = (int.parse(ctrl.text) + 1).toString()))
          ]))
    ]);
  }

  void getPageData() async {
    await WebService.funBookingSetting().then((value) {
      if (value.status == "success") {
        bs = value;

        controller[0].text = bs.data[0].advanceBookingStartDays.toString();
        controller[1].text = bs.data[0].advanceBookingHours.toString();
        controller[2].text = bs.data[0].slotLength.toString();
        controller[3].text = bs.data[0].bookingPerSlot.toString();
        controller[4].text = bs.data[0].bookingPerDay.toString();

        setState(() {
          controller[5].text = bs.data[0].announcement;
        });
      }
    });
  }

  void funSublim() async {
    Map _map = {
      "start_time": "00:00",
      "end_time": "00:00",
      "advance_booking_start_days": controller[0].text,
      "advance_booking_hours": controller[1].text,
      "slot_length": controller[2].text,
      "booking_per_slot": controller[3].text,
      "booking_per_day": controller[4].text,
      "announcement": controller[5].text
    };
    print("controller[2].text:${controller[2].text}");
    await WebService.funBookingSaveSetting(_map,context).then((value) {
      if (value.status == "success") BotToast.showText(text: value.message);
    });
  }
}
