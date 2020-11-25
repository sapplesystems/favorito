import 'package:Favorito/component/DatePicker.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/model/booking/BookingModel.dart';
import 'package:Favorito/model/booking/SlotData.dart';
import 'package:Favorito/model/booking/bookingListModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/appoinment/ManualAppoinment.dart';
import 'package:Favorito/ui/appoinment/appoinmentSetting.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/SizeManager.dart';
import 'package:url_launcher/url_launcher.dart';

class Appoinment extends StatefulWidget {
  @override
  _Appoinment createState() => _Appoinment();
}

class _Appoinment extends State<Appoinment> {
  SizeManager sm;
  // List<String> _daysList = ['Today'];
  // List<Slots> _slotInputList = [];
  List<User> _userInputList = [];
  // String _selectedDay = 'Today';
  String _selectedDateText = 'Select Date';
  // List<BookingModel> _inputList = [];
  bookingListModel blm = bookingListModel();
  DateTime _initialDate;
  int selectedSlot = 0;
  @override
  void initState() {
    super.initState();
    getPageData();
    _initialDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: Colors.black //change your color here
              ),
          title: Text("Appoinment", style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                size: 34,
              ),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManualAppoinment()))
                    .whenComplete(() {
                  getPageData();
                });
              },
            ),
            IconButton(
              icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => appoinmentSetting()));
              },
            )
          ],
        ),
        body: blm.slots == null
            ? Center(child: Text('Please wait its loading...'))
            : ListView(children: [
                Container(
                    height: sm.scaledHeight(6),
                    padding:
                        EdgeInsets.symmetric(horizontal: sm.scaledWidth(30)),
                    child: SizedBox(
                      width: sm.scaledWidth(40),
                      child: DatePicker(
                        selectedDateText: _selectedDateText,
                        selectedDate: _initialDate,
                        onChanged: ((value) {
                          _selectedDateText = value;
                        }),
                      ),
                    )),
                Container(
                  height: sm.scaledHeight(24),
                  margin: EdgeInsets.symmetric(
                      vertical: sm.scaledHeight(4),
                      horizontal: sm.scaledWidth(8)),
                  child: GridView.builder(
                    itemCount: blm.slots.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: sm.scaledWidth(3),
                        mainAxisSpacing: sm.scaledHeight(0)),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => setState(() {
                          selectedSlot = index;
                        }),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: blm.slots[index].slotData.length <
                                          blm.count_per_slot
                                      ? myRed
                                      : myGrey,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)),
                                ),
                                width: sm.scaledWidth(10),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                      "${blm.slots[index].slotStart}-${blm.slots[index].slotEnd}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        backgroundColor:
                                            blm.slots[index].slotData.length <
                                                    blm.count_per_slot
                                                ? myRed
                                                : myGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: sm.scaledWidth(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 8.0,
                                      bottom: 8.0),
                                  child: Center(
                                    child: Text(
                                        "${blm.slots[index].slotData.length ?? 0}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            backgroundColor: Colors.white)),
                                  ),
                                ),
                              ),
                            ]),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: round30,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "User Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        height: sm.scaledHeight(40),
                        child: ListView.builder(
                            itemCount: blm.slots.length != 0
                                ? blm.slots[selectedSlot].slotData.length
                                : 0,
                            itemBuilder: (BuildContext context, int _index) {
                              var va = blm.slots[selectedSlot].slotData[_index];

                              return InkWell(
                                onTap: () {
                                  BotToast.showText(text: "UnderProcess");
                                },
                                child: Card(
                                    elevation: 2,
                                    shape: rrb,
                                    borderOnForeground: true,
                                    child: InkWell(
                                      onTap: () {
                                        // showPopup(context, _popupBody(va));
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "${va.createdDate} | ${blm.slots[selectedSlot].slotStart} - ${blm.slots[selectedSlot].slotEnd}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                var _data = blm
                                                    .slots[selectedSlot]
                                                    .slotData[_index];
                                                var _i = _index;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ManualAppoinment(
                                                                data: va,
                                                                start: blm
                                                                    .slots[
                                                                        selectedSlot]
                                                                    .slotStart,
                                                                end: blm
                                                                    .slots[
                                                                        selectedSlot]
                                                                    .slotEnd))).whenComplete(
                                                    () => getPageData());
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: myRed,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              va.name,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black),
                                            ),
                                            subtitle: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: AutoSizeText(
                                                va.specialNotes,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 12,
                                                maxFontSize: 14,
                                              ),
                                            ),
                                            trailing: InkWell(
                                              onTap: () =>
                                                  launch("tel://${va.contact}"),
                                              child: Container(
                                                decoration: bd1Red,
                                                padding: EdgeInsets.all(6),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Icon(
                                                  Icons.call,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ]));
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(30),
        left: sm.scaledWidth(10),
        right: sm.scaledWidth(10),
        bottom: sm.scaledHeight(30),
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBody(SlotData model) {
    return Container(child: null);
  }

  void getPageData() async {
    await WebService.funAppoinmentList(context).then((value) {
      if (value.status == "success") {
        setState(() {
          blm = value;
        });
      }
    });
  }
}
