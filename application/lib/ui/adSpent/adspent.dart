import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/CreateCampaign/CreateCampaign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import '../../model/adSpentModel.dart';

class adSpent extends StatefulWidget {
  @override
  _adSpentState createState() => _adSpentState();
}

class _adSpentState extends State<adSpent> {
  SizeManager sm;
  int totalSpent = 0;
  int freeCredit = 0;
  int paidCredit = 0;
  List<Data> list = [];
  Data data = Data();

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
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
                              builder: (context) =>
                                  CreateCampaign(false, null)))
                      .whenComplete(() => getPageData());
                })
          ],
        ),
        body: Container(
            height: sm.h(87.5),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(padding: const EdgeInsets.all(28.0), child: topArea()),
                Card(
                    shape: rrbTop,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: sm.w(2), vertical: sm.w(8)),
                      child: Column(
                        children: [
                          Container(
                            height: sm.h(64),
                            child: ListView(
                              children: [
                                for (int i = 0;
                                    i < (list != null ? list.length : 0);
                                    i++)
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        data = list[i];
                                        return CreateCampaign(true, data);
                                      })).whenComplete(() => getPageData());
                                    },
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${list[i].name}\n"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("CPC:${list[i].cpc}\$",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    Text(
                                                        "Impressions:${list[i].impressions}",
                                                        style: TextStyle(
                                                            fontSize: 16))
                                                  ],
                                                ),
                                                Container(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Spent:${list[i].totalBudget}\$",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    Text(
                                                        "Click:${list[i].clicks}",
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
                                    left: sm.w(22),
                                    right: sm.w(2),
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
      Text("$title : $ammount"),
      SvgPicture.asset(
        ico,
        alignment: Alignment.center,
        height: sm.h(1.4),
      )
    ]);
  }

  Widget topArea() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        Text("Total Spent", style: TextStyle(color: Colors.grey)),
        RichText(
            text: TextSpan(
                text: totalSpent.toString(),
                style: TextStyle(
                    color: Colors.black, fontSize: 28, letterSpacing: 1),
                children: <TextSpan>[
              TextSpan(
                  text: '\$',
                  style: TextStyle(color: Colors.red, letterSpacing: 4)),
            ]))
      ]),
      Column(children: [
        credit("Free Credit", freeCredit.toString(), "assets/icon/warning.svg"),
        credit("Paid Credit", paidCredit.toString(), "null")
      ]),
    ]);
  }

  void getPageData() {
    WebService.getAdSpentPageData(context).then((value) {
      if (value.status == "success") {
        setState(() {
          totalSpent = value.totalSpent;
          freeCredit = value.freeCredit;
          paidCredit = value.paidCredit;
          list.clear();
          list.addAll(value.data);
        });
      }
    });
  }
}
