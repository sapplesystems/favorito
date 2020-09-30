import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  bool switchControl;
  ToggleSwitch({this.switchControl});
  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  void toggleSwitch(bool value) {
    if (widget.switchControl == false)
      setState(() => widget.switchControl = true);
    else
      setState(() => widget.switchControl = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Switch(
        onChanged: toggleSwitch,
        value: widget.switchControl,
        activeColor: myRed,
        activeTrackColor: myRedLight,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey,
      ),
    );
  }
}
