import 'dart:async';
import 'dart:ui';
import 'package:Favorito/component/MyGoogleMap.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessSetting extends StatefulWidget {
  @override
  _BusinessSettingState createState() => _BusinessSettingState();
}

class _BusinessSettingState extends State<BusinessSetting> {
  CameraPosition _initPosition =
      CameraPosition(target: LatLng(27.1751, 78.0421), zoom: 10.5);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marker = {};
  @override
  void initState() {
    super.initState();
    // checksPermission();
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
            color: Colors.white, //change your color here
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ListView(children: [
            Text(
              "Business Settings",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            Container(
                width: context.percentWidth * 98,
                height: context.percentHeight * 212,
                child: Stack(children: [
                  Positioned(
                      top: context.percentHeight * 7,
                      left: context.percentWidth * 8,
                      right: context.percentWidth * 8,
                      child: Container(
                          decoration: bd1,
                          margin: EdgeInsets.only(
                              bottom: context.percentHeight * 0),
                          height: context.percentHeight * 200,
                          padding: EdgeInsets.symmetric(
                              horizontal: context.percentWidth * 6,
                              vertical: context.percentHeight * 4),
                          child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: context.percentHeight * 4),
                                  child: Image.asset(
                                    // 'assets/icon/save.svg',
                                    'assets/icon/foodcircle.png',
                                    fit: BoxFit.cover,
                                    height: context.percentHeight * 20,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Business Name",
                                      security: false,
                                      hint: "Enter business name",
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Business Phone",
                                      security: false,
                                      hint: "Enter business phone",
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "LandLine",
                                      security: false,
                                      hint: "Enter Landline number",
                                    )),
                                Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(children: [Text("Business Hours")]),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Column(children: [
                                                  Text(" Mon - Fri ",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text("11:30 - 23:00",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ])
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Column(children: [
                                                  Text(" Mon - Fri ",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text("11:30 - 23:00",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ])
                                              ],
                                            ),
                                            Text("Add",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ],
                                        )
                                      ],
                                    )),
                                Container(
                                  height: 250,
                                  child: MyGoogleMap(
                                      controller: _controller,
                                      initPosition: _initPosition,
                                      marker: _marker),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Address",
                                      security: false,
                                      hint: "Enter Address",
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Pincode",
                                      security: false,
                                      hint: "Enter Pincode",
                                    )),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: FindDropdown(
                                        // key: _spidKey,
                                        items: ["gr noida", "noida"],
                                        label: "Town/City",
                                        onChanged: (String item) {})),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: FindDropdown(
                                        // key: _spidKey,
                                        items: ["Delhi", "up"],
                                        label: "State",
                                        selectedItem: "up",
                                        showClearButton: true,
                                        onChanged: (String item) {})),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: FindDropdown(
                                        // key: _spidKey,
                                        items: ["India"],
                                        label: "Country",
                                        selectedItem: "India",
                                        onChanged: (String item) {})),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Website",
                                      security: false,
                                      hint: "Enter Website",
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Email",
                                      security: false,
                                      hint: "Enter Email",
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: txtfieldboundry(
                                      title: "Short Description",
                                      maxLines: 3,
                                      security: false,
                                      hint: "Enter Description",
                                    )),
                              ]))),
                  Positioned(
                      top: context.percentHeight * 3,
                      left: context.percentWidth * 18,
                      right: context.percentWidth * 18,
                      child: Container(
                          decoration: bd1,
                          padding: EdgeInsets.symmetric(
                              horizontal: context.percentWidth * 4,
                              vertical: context.percentHeight * 2),
                          child: Column(children: [
                            Text(
                              "Your Business ID",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 4),
                            Text(
                              business_id,
                              style: TextStyle(fontSize: 14),
                            )
                          ])))
                ])),
            Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: context.percentWidth * 16),
                child: roundedButton(
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Done"))
          ]),
        ));
  }
}
