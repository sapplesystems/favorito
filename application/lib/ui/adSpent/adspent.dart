import 'package:Favorito/myCss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class adSpent extends StatefulWidget {
  @override
  _adSpentState createState() => _adSpentState();
}

class _adSpentState extends State<adSpent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffff4f4),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xfffff4f4),
          title: Text("Ad Spent", style: titleStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.black),
                onPressed: () {})
          ],
        ),
        body: Container(
            child: ListView(
          primary: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(children: [
                Column(children: [
                  Text("Total Spent", style: TextStyle(color: Colors.grey)),
                  RichText(
                      text: TextSpan(
                          text: '500',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              letterSpacing: 1),
                          children: <TextSpan>[
                        TextSpan(
                            text: '\$',
                            style:
                                TextStyle(color: Colors.red, letterSpacing: 4)),
                      ]))
                ]),
                Column(children: [
                  credit("Free Credit", "200", "assets/icon/warning.svg"),
                  credit("Paid Credit", "100", "null")
                ]),
              ]),
            ),
            Column()
          ],
        )));
  }

  Widget credit(String title, String ammount, String ico) {
    return Row(children: [
      Text("${title} : "),
      Text("${ammount}  "),
      SvgPicture.asset(
        ico,
        alignment: Alignment.center,
        height: context.percentHeight * 1.4,
      )
    ]);
  }
}
