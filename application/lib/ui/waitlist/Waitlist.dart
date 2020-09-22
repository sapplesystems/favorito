import 'package:flutter/material.dart';

class Waitlist extends StatefulWidget {
  @override
  _Waitlist createState() => _Waitlist();
}

class _Waitlist extends State<Waitlist> {
  @override
  Widget build(BuildContext context) {
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
          "Notification",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
