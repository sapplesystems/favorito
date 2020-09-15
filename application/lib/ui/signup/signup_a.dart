import 'package:application/component/roundedButton.dart';
import 'package:application/component/txtfieldboundry.dart';
import 'package:application/myCss.dart';
import 'package:application/network/webservices.dart';
import 'package:application/ui/signup/signup_b.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dropdown_search/dropdown_search.dart';

class signup_a extends StatefulWidget {
  @override
  _signup_aState createState() => _signup_aState();
}

class _signup_aState extends State<signup_a> {
  List<String> busy = [];
  List<String> cat = [];
  @override
  void initState() {
    super.initState();
    getBusiness();
    getCategory();
  }

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
      ),
      body: Container(
        color: Color(0xfffff4f4),
        height: context.percentHeight * 90,
        child: Stack(
          children: [
            Positioned(
              left: context.percentWidth * 30,
              right: context.percentWidth * 30,
              child: Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "Gilroy-Bold",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              bottom: context.percentWidth * 4,
              left: context.percentWidth * 20,
              right: context.percentWidth * 20,
              child: roundedButton(
                clicker: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signup_b()));
                },
                clr: Colors.red,
                title: "Next",
              ),
            ),
            Positioned(
              top: context.percentWidth * 30,
              left: context.percentWidth * 10,
              right: context.percentWidth * 10,
              child: Container(
                height: context.percentWidth * 100,
                decoration: bd1,
                padding: EdgeInsets.only(
                  top: context.percentHeight * 8,
                  left: context.percentWidth * 2,
                  right: context.percentWidth * 2,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSelectedItem: true,
                            items: busy,
                            label: "Business Type",
                            hint: "Please Select Business Type",
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            onChanged: print,
                            selectedItem: ""),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Business Name", security: false)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownSearch<String>(
                            mode: Mode.MENU,
                            showSelectedItem: true,
                            items: cat,
                            label: "Business Category",
                            hint: "Please Select Business Category",
                            // popupItemDisabled: (String s) => s.startsWith('I'),
                            onChanged: print,
                            selectedItem: ""),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Postal Cado", security: false)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: txtfieldboundry(
                              title: "Business Phone", security: false)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: context.percentWidth * 5,
                left: context.percentWidth * 30,
                right: context.percentWidth * 30,
                child: SvgPicture.asset('assets/icon/maskgroup.svg',
                    alignment: Alignment.center,
                    height: context.percentHeight * 20)),
          ],
        ),
      ),
    );
  }

  void getCategory() {}

  void getBusiness() {
    WebService.funGetBusyList().then((value) {
      for (int i = 0; i < value.data.length; i++) {
        setState(() {
          busy.add(value.data[0].typeName);
        });
      }
      print(busy.toString());
    });
  }
}
