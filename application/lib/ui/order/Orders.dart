import 'package:Favorito/config/SizeManager.dart';
import 'package:Favorito/model/order/OrderModel.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:icon_text_button/icon_text_button.dart';

class Orders extends StatefulWidget {
  @override
  _Orders createState() => _Orders();
}

class _Orders extends State<Orders> {
  List<OrderModel> newOrdersList = [];
  List<OrderModel> allOrdersList = [];
  List<OrderModel> inputOrdersList = [];
  String selectedTab = 'New Orders';
  SizeManager sm;

  @override
  void initState() {
    setState(() {
      OrderModel model = OrderModel();
      model.name = 'Rahul Sharma';
      model.mobile = '9876543210';
      model.date = '24 july 2020';
      model.time = '22:00';
      model.amount = 'Rs. 800';
      model.mode = 'Takeaway';
      model.paymentType = 'COD';
      String item1 = '2 x Reebok Shoes';
      String item2 = '2 x Puma Shoes';
      model.itemList = [];
      model.itemList.add(item1);
      model.itemList.add(item2);
      newOrdersList.add(model);
      newOrdersList.add(model);

      allOrdersList.add(model);
      allOrdersList.add(model);
      allOrdersList.add(model);
      allOrdersList.add(model);

      inputOrdersList.add(model);
      inputOrdersList.add(model);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
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
          title: Text(
            "Orders",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: myBackGround,
            ),
            height: sm.scaledHeight(100),
            child: Column(
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
                          for (var temp in newOrdersList) {
                            OrderModel model = OrderModel();
                            model.name = temp.name;
                            model.mobile = temp.mobile;
                            model.date = temp.date;
                            model.time = temp.time;
                            model.amount = temp.amount;
                            model.mode = temp.mode;
                            model.paymentType = temp.paymentType;
                            model.itemList = [];
                            for (var temp1 in temp.itemList) {
                              String item = temp1;
                              model.itemList.add(item);
                            }
                            inputOrdersList.add(model);
                          }
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
                          for (var temp in allOrdersList) {
                            OrderModel model = OrderModel();
                            model.name = temp.name;
                            model.mobile = temp.mobile;
                            model.date = temp.date;
                            model.time = temp.time;
                            model.amount = temp.amount;
                            model.mode = temp.mode;
                            model.paymentType = temp.paymentType;
                            model.itemList = [];
                            for (var temp1 in temp.itemList) {
                              String item = temp1;
                              model.itemList.add(item);
                            }
                            inputOrdersList.add(model);
                          }
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
                  padding: const EdgeInsets.all(8.0),
                  height: sm.scaledHeight(80),
                  child: ListView.builder(
                      itemCount: inputOrdersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: sm.scaledHeight(22),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
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
                                          child: Text(
                                            "${inputOrdersList[index].name} (${inputOrdersList[index].mobile})",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 8.0),
                                          child: Text(
                                            "${inputOrdersList[index].date} at ${inputOrdersList[index].time}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, right: 16.0),
                                      child: IconButton(
                                        iconSize: sm.scaledWidth(8),
                                        icon: Icon(Icons.call),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, top: 8.0),
                                          child: Text(
                                            "Items : ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        for (var item
                                            in inputOrdersList[index].itemList)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 8.0),
                                            child: AutoSizeText(
                                              "$item",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                              maxLines: 2,
                                              minFontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, top: 8.0),
                                      child: Text(
                                        "Total : ${inputOrdersList[index].amount} | ${inputOrdersList[index].mode} | ${inputOrdersList[index].paymentType}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconTextButton(
                                            icon: Icon(Icons.check_circle),
                                            label: Text('Accept'),
                                            onPress: null,
                                            padding: EdgeInsets.all(0.0),
                                            bgColor: Colors.white,
                                            color: Colors.white,
                                            btnType: BtnType.flat,
                                          ),
                                          IconTextButton(
                                            icon: Icon(Icons.close),
                                            label: Text('Reject'),
                                            onPress: null,
                                            padding: EdgeInsets.all(0.0),
                                            bgColor: Colors.white,
                                            color: Colors.white,
                                            btnType: BtnType.flat,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            )));
  }
}
