import 'package:flutter/material.dart';

class FullPhoto extends StatelessWidget {
  final String url;
  FullPhoto({Key key, @required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Full Image",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Image.network(
          url,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ));
  }
}
