import 'package:Favorito/component/CustomSwitch.dart';
import 'package:Favorito/component/TimePicker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/menu/MenuSettingModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils/myString.dart';

class MenuSetting extends StatefulWidget {
  @override
  _MenuSettingState createState() => _MenuSettingState();
}

class _MenuSettingState extends State<MenuSetting> {
  ProgressDialog pr;
  // bool _isAcceptingOrdersSwitch = true;
  // bool _isTakeAwaySwitch = true;
  // bool _isDineInSwicth = true;
  // bool _isDeliverySwitch = true;

  TimeOfDay _intitialTime = TimeOfDay.now();

  String _selectedTakeAwayStartTimeText;
  String _selectedTakeAwayEndTimeText;
  String _selectedDineInStartTimeText;
  String _selectedDineInEndTimeText;
  String _selectedDeliveryStartTimeText;
  String _selectedDeliveryEndTimeText;

  var _myTakeAwayMinimumAmountEditController = TextEditingController();
  var _myTakeAwayPackagingEditController = TextEditingController();
  var _myDeliveryMinimumAmountEditController = TextEditingController();
  var _myDeliveryPackagingEditController = TextEditingController();
  var fut;
  initializeValues() {}

  @override
  void initState() {
    initializeValues();
    super.initState();
    fut = WebService.funMenuSetting();
  }

  @override
  void didChangeDependencies() {
    _selectedTakeAwayStartTimeText = _intitialTime.format(context);
    _selectedTakeAwayEndTimeText = _intitialTime.format(context);
    _selectedDineInStartTimeText = _intitialTime.format(context);
    _selectedDineInEndTimeText = _intitialTime.format(context);
    _selectedDeliveryStartTimeText = _intitialTime.format(context);
    _selectedDeliveryEndTimeText = _intitialTime.format(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);

    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Fetching Data, please wait');
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            "Menu Setting",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder<MenuSettingModel>(
          future: fut,
          builder:
              (BuildContext context, AsyncSnapshot<MenuSettingModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text(loading));
            else if (snapshot.hasError)
              return Center(child: Text("Something went wrong..."));
            else {
              var v = snapshot.data.data;
              _selectedTakeAwayStartTimeText =
                  v.takeAwayStartTime.trim().substring(0, 5);
              _selectedTakeAwayEndTimeText =
                  v.takeAwayEndTime.trim().substring(0, 5);
              _myTakeAwayMinimumAmountEditController.text =
                  v.takeAwayMinimumBill.toString();
              _myTakeAwayPackagingEditController.text =
                  v.takeAwayPackagingCharge.toString();
              //dining
              _selectedDineInStartTimeText =
                  v.dineInStartTime.trim().substring(0, 5);
              _selectedDineInEndTimeText =
                  v.dineInEndTime.trim().substring(0, 5);
              //delevery
              _selectedDeliveryStartTimeText =
                  v.deliveryStartTime.trim().substring(0, 5);
              _selectedDeliveryEndTimeText =
                  v.deliveryEndTime.trim().substring(0, 5);
              _myDeliveryMinimumAmountEditController.text =
                  v.deliveryMiniumBill.toString();
              _myDeliveryPackagingEditController.text =
                  v.deliveryPackagingCharge.toString();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Accepting Orders",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        CustomSwitch(
                          value: v.acceptingOrder == 1,
                          activeColor: Color(0xff1dd100),
                          inactiveColor: Colors.red,
                          activeText: "Online",
                          inactiveText: "Offline",
                          activeTextColor: Colors.white,
                          inactiveTextColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              v.acceptingOrder = value ? 1 : 0;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Take Away",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Switch(
                            value: v.takeAway == 1,
                            onChanged: (value) {
                              setState(() {
                                v.takeAway = value ? 1 : 0;
                              });
                            },
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 30.0),
                      child: Text(
                        "Time",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: sm.w(20),
                            child: TimePicker(
                              selectedTimeText: _selectedTakeAwayStartTimeText,
                              selectedTime: _intitialTime,
                              onChanged: ((value) {
                                _selectedTakeAwayStartTimeText = value;
                              }),
                            ),
                          ),
                          SizedBox(
                            width: sm.w(20),
                            child: TimePicker(
                              selectedTimeText: _selectedTakeAwayEndTimeText,
                              selectedTime: _intitialTime,
                              onChanged: ((value) {
                                _selectedTakeAwayEndTimeText = value;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, top: 16.0, right: 16.0),
                      child: txtfieldboundry(
                        controller: _myTakeAwayMinimumAmountEditController,
                        title: "Minimum Bill",
                        hint: "Enter minimum amount",
                        security: false,
                        valid: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, top: 16.0, right: 16.0),
                      child: txtfieldboundry(
                        controller: _myTakeAwayPackagingEditController,
                        title: "Packaging Charge",
                        hint: "Enter packaging charge",
                        security: false,
                        valid: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dine-in",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Switch(
                            value: v.dineIn == 1,
                            onChanged: (value) {
                              setState(() {
                                v.dineIn = value ? 1 : 0;
                              });
                            },
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 32.0),
                      child: Text(
                        "Time",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: sm.w(20),
                          child: TimePicker(
                            selectedTimeText: _selectedDineInStartTimeText,
                            selectedTime: _intitialTime,
                            onChanged: ((value) {
                              _selectedDineInStartTimeText = value;
                            }),
                          ),
                        ),
                        SizedBox(
                          width: sm.w(20),
                          child: TimePicker(
                            selectedTimeText: _selectedDineInEndTimeText,
                            selectedTime: _intitialTime,
                            onChanged: ((value) {
                              _selectedDineInEndTimeText = value;
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Switch(
                            value: v.delivery == 1,
                            onChanged: (value) {
                              setState(() {
                                v.delivery = value ? 1 : 0;
                              });
                            },
                            activeTrackColor: Colors.grey,
                            activeColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 32.0),
                      child: Text(
                        "Time",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: sm.w(20),
                          child: TimePicker(
                            selectedTimeText: _selectedDeliveryStartTimeText,
                            selectedTime: _intitialTime,
                            onChanged: ((value) {
                              _selectedDeliveryStartTimeText = value;
                            }),
                          ),
                        ),
                        SizedBox(
                          width: sm.w(20),
                          child: TimePicker(
                            selectedTimeText: _selectedDeliveryEndTimeText,
                            selectedTime: _intitialTime,
                            onChanged: ((value) {
                              _selectedDeliveryEndTimeText = value;
                            }),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, top: 16.0, right: 16.0),
                      child: txtfieldboundry(
                        controller: _myDeliveryMinimumAmountEditController,
                        title: "Minimum Bill",
                        hint: "Enter minimum amount",
                        security: false,
                        valid: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, top: 16.0, right: 16.0),
                      child: txtfieldboundry(
                        controller: _myDeliveryPackagingEditController,
                        title: "Packaging Charge",
                        hint: "Enter packaging charge",
                        security: false,
                        valid: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(15), vertical: 16.0),
                      child: RoundedButton(
                        clicker: () async {
                          pr.show();
                          Map _map = {
                            "accepting_order": v.acceptingOrder,
                            "take_away": v.takeAway,
                            "take_away_start_time":
                                _selectedTakeAwayStartTimeText,
                            "take_away_end_time": _selectedTakeAwayEndTimeText,
                            "take_away_minimum_bill":
                                _myTakeAwayMinimumAmountEditController.text,
                            "take_away_packaging_charge":
                                _myTakeAwayPackagingEditController.text,
                            "dine_in": v.dineIn,
                            "dine_in_start_time": _selectedDineInStartTimeText,
                            "dine_in_end_time": _selectedDineInEndTimeText,
                            "delivery": v.delivery,
                            "delivery_start_time":
                                _selectedDeliveryStartTimeText,
                            "delivery_end_time": _selectedDeliveryEndTimeText,
                            "delivery_minium_bill":
                                _myDeliveryMinimumAmountEditController.text,
                            "delivery_packaging_charge":
                                _myDeliveryPackagingEditController.text
                          };
                          print("_map:${_map.toString()}");
                          await WebService.funMenuSettingUpdate(_map)
                              .then((value) {
                            pr.hide();
                            if (value.status == 'success')
                              Navigator.pop(context);
                            else
                              BotToast.showText(text: value.message);
                          });
                        },
                        clr: Colors.red,
                        title: "Save",
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
