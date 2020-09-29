import 'package:Favorito/myCss.dart';
import 'package:Favorito/ui/CreateCampaign/CreateCampaign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/utils/myColors.dart';
class adSpent extends StatefulWidget {
  @override
  _adSpentState createState() => _adSpentState();
}

class _adSpentState extends State<adSpent> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: myBackGround,
          title: Text("Ad Spent", style: titleStyle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateCampaign()));
                })
          ],
        ),
        body: Container(
            height: sm.scaledHeight(87.5),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: topArea(),
                ),
                Card(
                    shape: rrbTop,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.scaledWidth(2),
                          vertical: sm.scaledWidth(8)),
                      child: Column(
                        children: [
                          Container(
                            height: sm.scaledHeight(64),
                            // padding: EdgeInsets.only(bottom: 40),
                            child: ListView(
                              children: [
                                for (int i = 0; i < 10; i++)
                                  Card(
                                    elevation: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Restaurant Ad\n"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("CPC:2.3\$",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  Text("Impressions:12k",
                                                      style: TextStyle(
                                                          fontSize: 16))
                                                ],
                                              ),
                                              Container(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Spent:200\$",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  Text("Click:5k",
                                                      style: TextStyle(
                                                          fontSize: 16))
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: sm.scaledWidth(22),
                                    right: sm.scaledWidth(2),
                                  ),
                                  child: Image.asset(
                                    "assets/icon/reqCal.png",
                                    height: 20,
                                  ),
                                ),
                                Text("Request Callback", style: titleStyle1)
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
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
        height: sm.scaledHeight(1.4),
      )
    ]);
  }

  Widget topArea() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        Text("Total Spent", style: TextStyle(color: Colors.grey)),
        RichText(
            text: TextSpan(
                text: '500',
                style: TextStyle(
                    color: Colors.black, fontSize: 28, letterSpacing: 1),
                children: <TextSpan>[
              TextSpan(
                  text: '\$',
                  style: TextStyle(color: Colors.red, letterSpacing: 4)),
            ]))
      ]),
      Column(children: [
        credit("Free Credit", "200", "assets/icon/warning.svg"),
        credit("Paid Credit", "100", "null")
      ]),
    ]);
  }
}
