import 'package:flutter/material.dart';

class radios extends StatefulWidget {
  @override
  _radiosState createState() => _radiosState();
}

class _radiosState extends State<radios> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.radio_button_checked, color: Colors.red),
          Text("")
        ],
      ),
    );
  }
}
