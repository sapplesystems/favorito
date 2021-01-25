import 'package:Favorito/component/CustomSwitch.dart';
import 'package:Favorito/component/TimePicker.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class StoreSetting extends StatefulWidget {
  @override
  _StoreSettingState createState() => _StoreSettingState();
}

class _StoreSettingState extends State<StoreSetting> {
  bool _isAcceptingOrdersSwitch = true;
  bool _isStorePickupSwitch = true;
  bool _isDeliverySwitch = true;

  TimeOfDay _intitialTime = TimeOfDay.now();

  String _selectedStorePickupStartTimeText;
  String _selectedStorePickupEndTimeText;
  String _selectedDeliveryStartTimeText;
  String _selectedDeliveryEndTimeText;

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
    _selectedStorePickupStartTimeText = _intitialTime.format(context);
    _selectedStorePickupEndTimeText = _intitialTime.format(context);
    _selectedDeliveryStartTimeText = _intitialTime.format(context);
    _selectedDeliveryEndTimeText = _intitialTime.format(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
      appBar: AppBar(
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
                    "Store Pick up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: _isStorePickupSwitch,
                    onChanged: (value) {
                      setState(() {
                        _isStorePickupSwitch = value;
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
                    selectedTimeText: _selectedStorePickupStartTimeText,
                    selectedTime: _intitialTime,
                    onChanged: ((value) {
                      _selectedStorePickupStartTimeText = value;
                    }),
                  ),
                ),
                SizedBox(
                  width: sm.w(20),
                  child: TimePicker(
                    selectedTimeText: _selectedStorePickupEndTimeText,
                    selectedTime: _intitialTime,
                    onChanged: ((value) {
                      _selectedStorePickupEndTimeText = value;
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
              padding:
                  const EdgeInsets.only(left: 32.0, top: 16.0, right: 16.0),
              child: txtfieldboundry(
                controller: _myDeliveryMinimumAmountEditController,
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
                controller: _myDeliveryPackagingEditController,
                title: "Packaging Charge",
                hint: "Enter packaging charge",
                security: false,
                valid: true,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: sm.w(15), vertical: 16.0),
              child: RoundedButton(
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
