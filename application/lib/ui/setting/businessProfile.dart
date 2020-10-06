import 'dart:async';
import 'dart:ui';
import 'package:Favorito/component/MyGoogleMap.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/workingDateTime.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessProfile extends StatefulWidget {
  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  CameraPosition _initPosition =
      CameraPosition(target: LatLng(27.1751, 78.0421), zoom: 10.5);
  Completer<GoogleMapController> _GMapcontroller = Completer();
  Set<Marker> _marker = {};
  List<TextEditingController> _controller = List();
  @override
  void initState() {
    getBusinessProfileData();
    for (int i = 0; i < 10; i++) _controller.add(TextEditingController());
    super.initState();
  }

  getBusinessProfileData() {
    WebService.funGetBusinessProfileData().then((value) {
      setState(() {
        _businessProfileData = value;
      });
    });
  }

  final bool _autoValidateForm = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: null,
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/icon/save.svg',
                height: sm.scaledWidth(6.4),
              ),
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
              "Business Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
            Container(
                width: sm.scaledWidth(98),
                height: sm.scaledHeight(212),
                child: Builder(
                    builder: (context) => Form(
                          key: _formKey,
                          autovalidate: _autoValidateForm,
                          child: Stack(children: [
                            Positioned(
                                top: sm.scaledHeight(7),
                                left: sm.scaledWidth(6),
                                right: sm.scaledWidth(6),
                                child: Container(
                                    decoration: bd1,
                                    margin: EdgeInsets.only(
                                        bottom: sm.scaledHeight(0)),
                                    height: sm.scaledHeight(200),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sm.scaledWidth(6),
                                        vertical: sm.scaledHeight(4)),
                                    child: ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: sm.scaledHeight(4)),
                                            child: Image.network(
                                              // _businessProfileData.data.photo ==
                                              //         null?
                                              "https://source.unsplash.com/random/400*400",
                                              // : _businessProfileData
                                              // .data.photo,
                                              height: sm.scaledHeight(20),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                controller: _controller[0],
                                                title: "Business Name",
                                                security: false,
                                                hint: "Enter business name",
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                controller: _controller[1],
                                                title: "Business Phone",
                                                security: false,
                                                hint: "Enter business phone",
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                controller: _controller[2],
                                                title: "LandLine",
                                                security: false,
                                                maxlen: 12,
                                                keyboardSet:
                                                    TextInputType.number,
                                                hint: "Enter Landline number",
                                              )),
                                          Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(children: [
                                                    Text("Business Hours")
                                                  ]),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(children: [
                                                            Text(" Mon - Fri ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                "11:30 - 23:00",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200)),
                                                          ])
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(children: [
                                                            Text(" Mon - Fri ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                "11:30 - 23:00",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200)),
                                                          ])
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          showPopup(context,
                                                              _popupBodyShowDetail());
                                                        },
                                                        child: Text("Add",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                          Container(
                                            height: 250,
                                            child: MyGoogleMap(
                                                controller: _GMapcontroller,
                                                initPosition: _initPosition,
                                                marker: _marker),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                title: "Address",
                                                security: false,
                                                hint: "Enter Address",
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                title: "Pincode",
                                                security: false,
                                                hint: "Enter Pincode",
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: FindDropdown(
                                                  // key: _spidKey,
                                                  items: ["gr noida", "noida"],
                                                  label: "Town/City",
                                                  onChanged: (String item) {})),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: FindDropdown(
                                                  // key: _spidKey,
                                                  items: ["Delhi", "up"],
                                                  label: "State",
                                                  selectedItem: "up",
                                                  showClearButton: true,
                                                  onChanged: (String item) {})),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: FindDropdown(
                                                  // key: _spidKey,
                                                  items: ["India"],
                                                  label: "Country",
                                                  selectedItem: "India",
                                                  onChanged: (String item) {})),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                title: "Website",
                                                security: false,
                                                hint: "Enter Website",
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                title: "Email",
                                                security: false,
                                                hint: "Enter Email",
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: txtfieldboundry(
                                                title: "Short Description",
                                                maxLines: 3,
                                                security: false,
                                                hint: "Enter Description",
                                              )),
                                        ]))),
                            Positioned(
                                top: sm.scaledHeight(3),
                                left: sm.scaledWidth(18),
                                right: sm.scaledWidth(18),
                                child: Container(
                                    decoration: bd1,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: sm.scaledWidth(4),
                                        vertical: sm.scaledHeight(2)),
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
                          ]),
                        ))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: sm.scaledWidth(16)),
                child: roundedButton(
                    clicker: () {
                      // funSublim();
                    },
                    clr: Colors.red,
                    title: "Done"))
          ]),
        ));
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);
    Navigator.push(
      context,
      PopupLayout(
        top: sm.scaledHeight(10),
        left: sm.scaledWidth(2),
        right: sm.scaledWidth(2),
        bottom: sm.scaledHeight(2),
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }

  Widget _popupBodyShowDetail() {
    return Container(child: WorkingDateTime());
  }
}
