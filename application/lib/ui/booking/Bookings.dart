import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/model/booking/BookingModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/booking/BokingDetail.dart';
import 'package:Favorito/ui/booking/ManualBooking.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/SizeManager.dart';

class Bookings extends StatefulWidget {
  @override
  _Bookings createState() => _Bookings();
}

class _Bookings extends State<Bookings> {
  SizeManager sm;
  List<String> _daysList = ['Today'];
  List<Slots> _slotInputList = [];
  List<User> _userInputList = [];
  String _selectedDay = 'Today';

  List<BookingModel> _inputList = [];

  @override
  void initState() {
    setState(() {
      BookingModel model = BookingModel();
      model.day = 'Today';

      Slots slot = Slots();
      slot.slot = '10:30-11:30';
      slot.slotOccupancy = '5';
      slot.isFull = 'false';
      Slots slot1 = Slots();
      slot1.slot = '10:30-11:30';
      slot1.slotOccupancy = '5';
      slot1.isFull = 'false';
      Slots slot2 = Slots();
      slot2.slot = '10:30-11:30';
      slot2.slotOccupancy = '5';
      slot2.isFull = 'true';
      Slots slot3 = Slots();
      slot3.slot = '10:30-11:30';
      slot3.slotOccupancy = '5';
      slot3.isFull = 'false';
      Slots slot4 = Slots();
      slot4.slot = '10:30-11:30';
      slot4.slotOccupancy = '5';
      slot4.isFull = 'false';

      model.slotList.add(slot);
      model.slotList.add(slot1);
      model.slotList.add(slot2);
      model.slotList.add(slot3);
      model.slotList.add(slot4);

      User user = User();
      user.name = 'Jhon Hopkins';
      user.userNotes =
          'hsfk aslhkf shf lskagf salf ;jsfa saf jsa;f js;fj safj saf;jds flsd;fha sai;fh sea;if hasf;';
      user.slot = '13:00-14:00';
      user.date = '12 Jan';
      user.noOfPeople = '2 person';

      model.userList.add(user);
      model.userList.add(user);

      _inputList.add(model);

      int index = -1;
      for (var temp in _inputList) {
        if (temp.day == _selectedDay) {
          index = _inputList.indexOf(temp);
        }
      }
      _slotInputList.clear();
      for (var slot in _inputList[index].slotList) {
        _slotInputList.add(slot);
      }

      _userInputList.clear();
      for (var user in _inputList[index].userList) {
        _userInputList.add(user);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
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
            "Bookings",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset('assets/icon/addWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManualBooking()))
                    .whenComplete(() {
                  // call the page reload here
                });
              },
            ),
            IconButton(
              icon: SvgPicture.asset('assets/icon/settingWaitlist.svg',
                  alignment: Alignment.center),
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => CreateJob(null)));
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfffff4f4),
          ),
          height: sm.scaledHeight(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: sm.scaledWidth(20),
                    right: sm.scaledWidth(20),
                    top: 8.0,
                    bottom: 16.0),
                child: DropdownSearch<String>(
                  validator: (v) => v == '' ? "required field" : null,
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  selectedItem: _selectedDay,
                  items: _daysList != null ? _daysList : null,
                  label: "Day",
                  hint: "Please Select day",
                  showSearchBox: false,
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                      int index = -1;
                      for (var temp in _inputList) {
                        if (temp.day == _selectedDay) {
                          index = _inputList.indexOf(temp);
                        }
                      }
                      _slotInputList.clear();
                      for (var slot in _inputList[index].slotList) {
                        _slotInputList.add(slot);
                      }
                      _userInputList.clear();
                      for (var user in _inputList[index].userList) {
                        _userInputList.add(user);
                      }
                    });
                  },
                ),
              ),
              Container(
                height: sm.scaledHeight(25),
                margin: EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: _slotInputList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: sm.scaledWidth(5),
                      mainAxisSpacing: sm.scaledHeight(0)),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _slotInputList[index].isFull == 'true'
                                ? Colors.grey
                                : Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          width: sm.scaledWidth(10),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: Center(
                              child: Text(
                                _slotInputList[index].slot,
                                style: TextStyle(
                                  color: Colors.white,
                                  backgroundColor:
                                      _slotInputList[index].isFull == 'true'
                                          ? Colors.grey
                                          : Colors.red,
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
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: Center(
                              child: Text(_slotInputList[index].slotOccupancy,
                                  style: TextStyle(
                                      color: Colors.black,
                                      backgroundColor: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                height: sm.scaledHeight(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "User Details",
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sm.scaledHeight(40),
                      child: ListView.builder(
                          itemCount: _userInputList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: Container(
                                    height: sm.scaledHeight(18),
                                    margin: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showPopup(
                                                    context,
                                                    _popupBody(
                                                        _userInputList[index]));
                                              },
                                              child: Text(
                                                "${_userInputList[index].date} | ${_userInputList[index].slot} | ${_userInputList[index].noOfPeople} person",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: null)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showPopup(
                                                    context,
                                                    _popupBody(
                                                        _userInputList[index]));
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: sm.scaledWidth(60),
                                                    child: Text(
                                                      _userInputList[index]
                                                          .name,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: SizedBox(
                                                      width: sm.scaledWidth(60),
                                                      child: AutoSizeText(
                                                        _userInputList[index]
                                                            .userNotes,
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 12,
                                                        maxFontSize: 14,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.call),
                                                onPressed: null)
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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

  Widget _popupBody(User model) {
    // return Container(child: BookingDetail(userModel: model));
    return Container(child: null);
  }
}
