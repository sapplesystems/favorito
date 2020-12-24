import 'package:Favorito/config/SizeManager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Favorito/model/OrderDetail.dart';
import 'package:Favorito/myCss.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icon_text_button/icon_text_button.dart';

class Orders extends StatefulWidget {
  @override
  _Orders createState() => _Orders();
}

class _Orders extends State<Orders> {
  List<OrderData> allOrdersList = [];
  List<OrderData> newOrdersList = [];
  List<OrderData> inputOrdersList = [];
  String selectedTab = 'New Orders';
  SizeManager sm;

  @override
  void initState() {
    callPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: myBackGround,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: InkWell(
            onTap: () {
              callPageData();
            },
            child: Text(
              "Orders",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => {
                      setState(() {
                        selectedTab = 'New Orders';
                        inputOrdersList.clear();
                        for (var temp in allOrdersList)
                          if (temp.order.isAccepted == 0)
                            inputOrdersList.add(temp);
                      })
                    },
                    child: Text("New Orders",
                        style: TextStyle(
                            fontSize: 16.0,
                            decoration: selectedTab == 'New Orders'
                                ? TextDecoration.underline
                                : null)),
                  ),
                  Text("|"),
                  InkWell(
                    onTap: () => {
                      setState(() {
                        selectedTab = 'All Orders';
                        inputOrdersList.clear();
                        for (var temp in allOrdersList)
                          if (temp.order.isAccepted != 0)
                            inputOrdersList.add(temp);
                      })
                    },
                    child: Text("All Orders",
                        style: TextStyle(
                            fontSize: 16.0,
                            decoration: selectedTab == 'All Orders'
                                ? TextDecoration.underline
                                : null)),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  height: sm.scaledHeight(80),
                  child: ListView.builder(
                      itemCount: inputOrdersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, top: 12.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "${inputOrdersList[index].order.name}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                  Text(
                                                      "(${inputOrdersList[index].order.orderId})",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, top: 8.0),
                                              child: Text(
                                                "${inputOrdersList[index].order.orderDate}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                            onTap: () => launch(
                                                "tel://${inputOrdersList[index].order.mobile}"),
                                            child: Container(
                                                decoration: bd1Red,
                                                padding: EdgeInsets.all(6),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Icon(Icons.call,
                                                    color: Colors.white,
                                                    size: 20)))
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Items : ",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  buildDatailInRow(
                                                      inputOrdersList[index]
                                                          .detail),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  // maxLines: 2,
                                                  // minFontSize: 6,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "Total : ${inputOrdersList[index].order.totalAmount} | ${inputOrdersList[index].order.orderType} | ${inputOrdersList[index].order.payType} ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconTextButton(
                                                      icon: Icon(
                                                          Icons
                                                              .check_circle_outline,
                                                          color: myRed),
                                                      label: Text('Accept',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      onPress: null,
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      bgColor: Colors.white,
                                                      color: Colors.white,
                                                      btnType: BtnType.flat),
                                                  IconTextButton(
                                                      icon: Icon(
                                                          FontAwesomeIcons
                                                              .timesCircle,
                                                          color: myRed),
                                                      label: Text('Reject',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      onPress: null,
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      bgColor: Colors.white,
                                                      color: Colors.white,
                                                      btnType: BtnType.flat)
                                                ]))
                                      ])
                                ]));
                      }))
            ]));
  }

  String buildDatailInRow(var v) {
    String txt = '';
    for (var item in v) txt = txt + "${item.quantity} X ${item.categoryName}";
    return txt;
  }

  void callPageData() {
    WebService.orderList(null, context).then((value) {
      if (value.status == "success") {
        allOrdersList.addAll(value.data);
        setState(() {
          for (var va in allOrdersList)
            if (va.order.isAccepted == 0) inputOrdersList.add(va);
        });
      }
    });
  }
}
