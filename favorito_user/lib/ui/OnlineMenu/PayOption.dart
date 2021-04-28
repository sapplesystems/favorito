import 'package:favorito_user/ui/OnlineMenu/Paydata.dart';
import 'package:favorito_user/utils/MyColors.dart';

import 'package:flutter/material.dart';

List<String> payVia = ["lafayette", "jefferson", "jeffersonu"];

class PayOption extends StatefulWidget {
  @override
  _PayOptionState createState() => _PayOptionState();
}

class _PayOptionState extends State<PayOption> {
  List<PayData> payDataList;
  PayData selectedPayData;

  @override
  void initState() {
    payDataList = PayData.getPayData();
  }

  setSelectedPay(PayData payData) => setState(() => selectedPayData = payData);

  List<Widget> createPayDataList() {
    List<Widget> widget = [];
    for (PayData _data in payDataList) {
      widget.add(Container(
        height: 40,
        child: RadioListTile(
          value: _data,
          groupValue: selectedPayData,
          onChanged: (_v) {
            setSelectedPay(_v);
          },
          title: Text(_data.title),
          activeColor: myGreenDark,
          selected: selectedPayData == _data,
        ),
      ));
    }
    return widget;
  }

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: createPayDataList(),
          )),
    );
  }
}
