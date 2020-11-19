import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  bool switchControl;
  Function function;
  ToggleSwitch({this.switchControl, this.function});

  @override
  Widget build(BuildContext context) {
    print("$switchControl");
    return Container(
      child: Switch(
        onChanged: function(switchControl),
        value: switchControl,
        activeColor: myRed,
        activeTrackColor: myRedLight,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey,
      ),
    );
  }
}
