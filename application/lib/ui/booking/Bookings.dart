import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/model/booking/BookingModel.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/booking/BookingSetting.dart';
import 'package:Favorito/ui/booking/ManualBooking.dart';
import 'package:Favorito/utils/myColors.dart';
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
      user.userNotes = 'User Note wi';
      user.slot = '13:00-14:00';
      user.date = '12 Jan';
      user.noOfPeople = '2 person';

      model.userList.add(user);
      model.userList.add(user);
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
              icon: Icon(
                Icons.add_circle_outline,
                size: 34,
              ),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookingSetting()));
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xfffff4f4),
          ),
          height: sm.scaledHeight(100),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: sm.scaledHeight(6),
                padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(30)),
                child: DropdownSearch<String>(
                  validator: (v) => v == '' ? "required field" : null,
                  mode: Mode.MENU,
                  showSelectedItem: true,
                  selectedItem: _selectedDay,
                  items: _daysList != null ? _daysList : null,
                  label: "",
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
                height: sm.scaledHeight(24),
                margin: EdgeInsets.symmetric(
                    vertical: sm.scaledHeight(4),
                    horizontal: sm.scaledWidth(8)),
                child: GridView.builder(
                  itemCount: _slotInputList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: sm.scaledWidth(3),
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
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: round30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          "User Details",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Container(
                      height: sm.scaledHeight(50),
                      child: ListView.builder(
                          itemCount: _userInputList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                elevation: 2,
                                shape: rrb,
                                borderOnForeground: true,
                                child: InkWell(
                                  onTap: () {
                                    showPopup(context,
                                        _popupBody(_userInputList[index]));
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          "${_userInputList[index].date} | ${_userInputList[index].slot} | ${_userInputList[index].noOfPeople} person",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                        trailing: Icon(
                                          Icons.edit,
                                          color: myRed,
                                          size: 20,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          _userInputList[index].name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: AutoSizeText(
                                            _userInputList[index].userNotes,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 12,
                                            maxFontSize: 14,
                                          ),
                                        ),
                                        trailing: Container(
                                          decoration: bd1Red,
                                          padding: EdgeInsets.all(6),
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.call,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                        
                                      ),
                                    ],
                                  ),
                                ));
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
