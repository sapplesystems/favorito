import 'package:Favorito/model/menu/Category.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/menu/CallSwitcher.dart';
import 'package:Favorito/ui/menu/CategoryForm.dart';
import 'package:Favorito/ui/menu/MenuProvider.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:Favorito/model/menu/MenuBaseModel.dart';
import 'package:provider/provider.dart';
import '../../utils/myString.dart';

class CategoryPage extends StatefulWidget {
  String title;
  int id;
  CategoryPage({this.title, this.id});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  MenuProvider vaTrue;
  Category data = Category();

  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<MenuProvider>(context, listen: true);
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder<MenuBaseModel>(
      future: WebService.funMenuCatList({"category_id": widget.id}),
      builder: (BuildContext context, AsyncSnapshot<MenuBaseModel> data) {
        if (data.connectionState == ConnectionState.waiting)
          return Center(child: Text(loading));
        else if (data.hasError)
          return Center(child: Text("Something went wrong.."));
        else {
          vaTrue.callerIdSet(widget.id);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          Text(widget.title ?? "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          CallSwitcher(),
                          Text(
                            'Out of stock',
                            style: TextStyle(color: Colors.black, fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details : ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Gilroy-Medium'),
                    ),
                    Flexible(
                      child: Text(
                        data?.data?.data[0]?.details ?? "",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Activate time slots :',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Gilroy-Medium')),
                    Flexible(
                      child: Text(
                        '${data?.data?.data[0]?.slotStartTime?.trim()?.substring(0, 5)} - ${data?.data?.data[0]?.slotEndTime?.trim()?.substring(0, 5)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activate time slots :',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Gilroy-Medium'),
                    ),
                    Flexible(
                      child: Text(
                        '${data?.data?.data[0]?.availableOn}',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryForm(
                                          id: widget.id.toString(),
                                          data: data?.data?.data[0])))
                              .whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  color: myBackGround,
                                  border: Border.all(color: myRed),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Icon(
                                Icons.edit,
                                color: myRed,
                              ),
                            ),
                            Text(
                              'Edit Item',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    )));
  }
}
