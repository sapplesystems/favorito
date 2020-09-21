import 'package:application/component/txtfieldboundry.dart';
import 'package:application/myCss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class businessInfo extends StatefulWidget {
  @override
  _businessInfoState createState() => _businessInfoState();
}

class _businessInfoState extends State<businessInfo> {
  List<TextEditingController> ctrl = List();

  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) ctrl.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffff4f4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: null,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icon/save.svg'),
            onPressed: () {},
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Text("Business Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            Container(
              height: context.percentHeight * 24,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 10; i++)
                    Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg',
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                    )
                ],
              ),
            ),
            Container(
              width: context.percentWidth * 6.5,
              height: context.percentHeight * 6.5,
              margin: EdgeInsets.symmetric(
                horizontal: context.percentWidth * 14,
                vertical: context.percentHeight * 2,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xffdd2626),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text("Add more photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red, fontSize: 16, letterSpacing: 1)),
              ),
            ),
            Container(
                decoration: bd1,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: txtfieldboundry(
                          title: "Category",
                          valid: true,
                          ctrl: ctrl[0],
                          prefixIco: Icons.search,
                          security: false)),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: txtfieldboundry(
                          title: "Sub Category",
                          valid: true,
                          prefixIco: Icons.search,
                          ctrl: ctrl[0],
                          security: false)),
                  // Container(
                  //   height: 100,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [Text("Pizza")],
                  //   ),
                  // )
                ]))
          ],
        ),
      ),
    );
  }
}
