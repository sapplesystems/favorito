import 'package:Favorito/component/CustomSwitch.dart';
import 'package:Favorito/component/TimePicker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class MenuSetting extends StatefulWidget {
  @override
  _MenuSettingState createState() => _MenuSettingState();
}

class _MenuSettingState extends State<MenuSetting> {
  bool _isAcceptingOrdersSwitch = true;
  bool _isTakeAwaySwitch = true;
  bool _isDineInSwicth = true;
  bool _isDeliverySwitch = true;

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

  initializeValues() {}

  @override
  void initState() {
    initializeValues();
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myBackGround,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Menu Setting",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  value: _isAcceptingOrdersSwitch,
                  activeColor: Colors.green,
                  inactiveColor: Colors.red,
                  activeText: "Online",
                  inactiveText: "Offline",
                  activeTextColor: Colors.white,
                  inactiveTextColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _isAcceptingOrdersSwitch = value;
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
                    value: _isTakeAwaySwitch,
                    onChanged: (value) {
                      setState(() {
                        _isTakeAwaySwitch = value;
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
                  width: sm.scaledWidth(20),
                  child: TimePicker(
                    selectedTimeText: _selectedTakeAwayStartTimeText,
                    selectedTime: _intitialTime,
                    onChanged: ((value) {
                      _selectedTakeAwayStartTimeText = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: sm.scaledWidth(20),
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
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
              child: txtfieldboundry(
                ctrl: _myTakeAwayMinimumAmountEditController,
                title: "Minimum Bill",
                hint: "Enter minimum amount",
                security: false,
                valid: true,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
              child: txtfieldboundry(
                ctrl: _myTakeAwayPackagingEditController,
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
                    value: _isDineInSwicth,
                    onChanged: (value) {
                      setState(() {
                        _isDineInSwicth = value;
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
                  width: sm.scaledWidth(20),
                  child: TimePicker(
                    selectedTimeText: _selectedDineInStartTimeText,
                    selectedTime: _intitialTime,
                    onChanged: ((value) {
                      _selectedDineInStartTimeText = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: sm.scaledWidth(20),
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
                    value: _isDeliverySwitch,
                    onChanged: (value) {
                      setState(() {
                        _isDeliverySwitch = value;
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
                  width: sm.scaledWidth(20),
                  child: TimePicker(
                    selectedTimeText: _selectedDeliveryStartTimeText,
                    selectedTime: _intitialTime,
                    onChanged: ((value) {
                      _selectedDeliveryStartTimeText = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: sm.scaledWidth(20),
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
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
              child: txtfieldboundry(
                ctrl: _myDeliveryMinimumAmountEditController,
                title: "Minimum Bill",
                hint: "Enter minimum amount",
                security: false,
                valid: true,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
              child: txtfieldboundry(
                ctrl: _myDeliveryPackagingEditController,
                title: "Packaging Charge",
                hint: "Enter packaging charge",
                security: false,
                valid: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sm.scaledWidth(15), vertical: 16.0),
              child: roundedButton(
                clicker: () {},
                clr: Colors.red,
                title: "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
