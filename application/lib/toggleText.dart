import 'package:flutter/material.dart';

class toggleText extends StatelessWidget {
  String hint, label;
  Function tapper;
  toggleText({this.hint, this.label, this.tapper});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: tapper,
        child: Container(
            width: 300,
            child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: label,
                  hintText: hint,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_drop_down_circle),
                  ),
                ),
                autofocus: false)));
  }
}
