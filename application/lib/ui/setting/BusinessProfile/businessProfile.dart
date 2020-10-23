import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:Favorito/component/MyGoogleMap.dart';
import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/component/workingDateTime.dart';
import 'package:Favorito/model/StateListModel.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class BusinessProfile extends StatefulWidget {
  @override
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile>
    with WidgetsBindingObserver {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  AppLifecycleState _appLifecycleState;
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  CameraPosition _initPosition;
  Completer<GoogleMapController> _GMapcontroller = Completer();
  Set<Marker> _marker = {};
  List<TextEditingController> _controller = List();
  Map<String, String> selecteddayList = {};
  int addressLength = 1;
  int webSiteLength = 1;
  List<String> cityList = ["Please Select ..."];
  List<CityModel> _cityModel = [];
  List<String> _stateList = ["Please Select ..."];
  List<StateList> _stateModel = [];
  bool _autoValidateForm = false;
  bool byAppointment = false;
  bool onWhatsapp = false;
  Position _position;
  int stateId = 0;
  int cityId = 0;
  List<String> addressList = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      imageQuality: 10,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() => _image = image);
    WebService.profileImageUpdate(image).then((value) {
      print("ImageUpdated:${value.message}");
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    getBusinessProfileData();
    WidgetsBinding.instance.addObserver(this);
    for (int i = 0; i < 16; i++) _controller.add(TextEditingController());

    super.initState();
    _cityWebData();
    _stateWebData();
    getProfileData();
  }

  _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _position = position;
      setState(() {
        _initPosition = CameraPosition(
            target: LatLng(_position.latitude, _position.longitude), zoom: 17);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void webSiteLengthPlus() {
    setState(() {
      webSiteLength = webSiteLength + 1;
      _controller.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.clear();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
      print("My App State: $_appLifecycleState");
    });
  }

  getBusinessProfileData() {
    WebService.funGetBusinessProfileData().then((value) {
      setState(() {
        _businessProfileData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return Scaffold(
        backgroundColor: myBackGround,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
        body: ListView(children: [
          Text(
            "Business Profile",
            textAlign: TextAlign.center,
            style: appBarStyle,
          ),
          Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
              child: Stack(children: [
                Card(
                  margin: EdgeInsets.only(top: sm.scaledHeight(10)),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Builder(
                    builder: (context) => Form(
                        key: _formKey,
                        autovalidate: _autoValidateForm,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(top: sm.scaledHeight(4)),
                                child: Stack(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: _image == null
                                          ? Image.network(
                                              _controller[0].text,
                                              height: sm.scaledHeight(20),
                                              width: sm.scaledWidth(72),
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: sm.scaledHeight(20),
                                              width: sm.scaledWidth(78),
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                              ))),
                                  Positioned(
                                      child: IconButton(
                                          onPressed: () =>
                                              getImage(ImgSource.Gallery),
                                          icon: Icon(Icons
                                              .center_focus_strong_outlined),
                                          color: Colors.deepOrange))
                                ])),
                            txtfieldboundry(
                              controller: _controller[1],
                              title: "Business Name",
                              security: false,
                              valid: true,
                              hint: "Enter business name",
                            ),
                            txtfieldboundry(
                              controller: _controller[2],
                              title: "Business Phone",
                              security: false,
                              maxlen: 10,
                              keyboardSet: TextInputType.number,
                              valid: true,
                              hint: "Enter business phone",
                            ),
                            txtfieldboundry(
                              controller: _controller[3],
                              title: "LandLine",
                              valid: false,
                              security: false,
                              maxlen: 12,
                              keyboardSet: TextInputType.number,
                              hint: "Enter Landline number",
                            ),
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                    validator: (_v) {
                                      var va;
                                      if (_v == "") {
                                        va = 'required field';
                                      } else {
                                        va = null;
                                      }
                                      return va;
                                    },
                                    autoValidate: _autoValidateForm,
                                    mode: Mode.MENU,
                                    showSelectedItem: true,
                                    selectedItem: _controller[4].text,
                                    items: ["Select Hours", "Always Open"],
                                    label: "Working Hours",
                                    hint: "Please Select Town/City",
                                    showSearchBox: false,
                                    onChanged: (value) {
                                      setState(() {
                                        _controller[4].text =
                                            value != null ? value : "";
                                      });
                                    })),

                            //  InkWell(
                            //   onTap: () {
                            //     setState(() {
                            //       onWhatsapp = !onWhatsapp;
                            //     });
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         vertical: 16, horizontal: 20),
                            //     child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text("Reach On Whatsapp",
                            //               style: TextStyle(
                            //                   fontSize: 16,
                            //                   color: Colors.grey)),
                            //           Icon(
                            //             onWhatsapp == false
                            //                  ? Icons.check_box
                            //                 : Icons.check_box_outline_blank,
                            //             color: onWhatsapp == false
                            //                 ? Colors.red
                            //                 : Colors.grey,
                            //           )
                            //         ]),
                            //   ),
                            // ),

                            Visibility(
                              visible: _controller[4].text == "Select Hours",
                              child: Padding(
                                padding: EdgeInsets.only(left: 18, right: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Business Hours",
                                            style: TextStyle(color: myGrey)),
                                        InkWell(
                                          onTap: () => setState(
                                              () => selecteddayList.clear()),
                                          child: Text("Reset",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: sm.scaledWidth(1)),
                                          width: sm.scaledWidth(60),
                                          height: sm.scaledWidth(14),
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              for (int i = 0;
                                                  i < selecteddayList.length;
                                                  i++)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(children: [
                                                        Text(
                                                            selecteddayList.keys
                                                                .toList()[i],
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        Text(
                                                            selecteddayList[
                                                                selecteddayList
                                                                        .keys
                                                                        .toList()[
                                                                    i]],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200)),
                                                      ])
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showPopup(context,
                                                _popupBodyShowDetail());
                                          },
                                          child: Text("Add",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  byAppointment = !byAppointment;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("By Appointment Only",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey)),
                                      Icon(
                                        byAppointment == false
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: byAppointment == false
                                            ? Colors.red
                                            : Colors.grey,
                                      )
                                    ]),
                              ),
                            ),
                            Container(
                              //_controller[6] is allign for this
                              height: 250,
                              child: _initPosition != null
                                  ? MyGoogleMap(
                                      controller: _GMapcontroller,
                                      initPosition: _initPosition,
                                      marker: _marker)
                                  : Container(),
                            ),
                            for (int i = 0; i < addressLength; i++)
                              txtfieldPostAction(
                                  ctrl: _controller[i + 6],
                                  hint: "Enter Address ${i + 1}",
                                  title: "Address ${i + 1}",
                                  maxLines: 1,
                                  valid: true,
                                  sufixColor: myRed,
                                  sufixTxt: "Add Line",
                                  security: false,
                                  sifixClick: () {
                                    setState(() {
                                      if (addressLength < 3)
                                        addressLength = addressLength + 1;
                                    });
                                  }),
                            txtfieldboundry(
                                controller: _controller[9],
                                title: "Pincode",
                                security: false,
                                valid: true,
                                maxlen: 6,
                                keyboardSet: TextInputType.number,
                                hint: "Enter Pincode",
                                myOnChanged: (_val) {
                                  pinCaller(_val);
                                }),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DropdownSearch<String>(
                                autoValidate: _autoValidateForm,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                validator: (_v) {
                                  var va;
                                  if (_v == "") {
                                    va = 'required field';
                                  } else {
                                    va = null;
                                  }
                                  return va;
                                },
                                selectedItem: _controller[10].text,
                                items: cityList != null ? cityList : null,
                                label: "Town/City",
                                hint: "Please Select Town/City",
                                showSearchBox: true,
                                onChanged: (value) {
                                  setState(() {
                                    _controller[10].text = value;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: DropdownSearch<String>(
                                validator: (_v) {
                                  var va;
                                  if (_v == "") {
                                    va = 'required field';
                                  } else {
                                    va = null;
                                  }
                                  return va;
                                },
                                autoValidate: _autoValidateForm,
                                mode: Mode.MENU,
                                showSelectedItem: true,
                                selectedItem: _controller[11].text,
                                items: _stateList != null ? _stateList : null,
                                label: "State",
                                hint: "Please Select State",
                                showSearchBox: true,
                                onChanged: (_value) {
                                  setState(() {
                                    _controller[11].text = _value;
                                    _controller[12].text = "India";
                                  });
                                },
                              ),
                            ),
                            txtfieldboundry(
                              controller: _controller[12],
                              title: "Country",
                              security: false,
                              valid: false,
                              isEnabled: false,
                              hint: "Enter Country",
                            ),
                            txtfieldboundry(
                              controller: _controller[13],
                              title: "Email",
                              security: false,
                              valid: true,
                              hint: "Enter Email",
                            ),
                            txtfieldboundry(
                              title: "Short Description",
                              controller: _controller[14],
                              maxLines: 3,
                              valid: true,
                              security: false,
                              hint: "Enter Description",
                            ),
                            for (int i = 0; i < webSiteLength; i++)
                              txtfieldPostAction(
                                  ctrl: _controller[i + 15],
                                  hint: "Enter Website ",
                                  title: "Website ",
                                  maxLines: 1,
                                  valid: false,
                                  sufixColor: myRed,
                                  sufixTxt: "Add Line",
                                  security: false,
                                  sifixClick: () {
                                    webSiteLengthPlus();
                                  }),
                          ]),
                        )),
                  ),
                ),
                Positioned(
                    top: sm.scaledHeight(5),
                    left: sm.scaledWidth(14),
                    right: sm.scaledWidth(14),
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
              ])),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: sm.scaledWidth(60),
              margin: EdgeInsets.only(bottom: 12.0),
              child: roundedButton(
                  clicker: () {
                    print(_controller);
                    if (_formKey.currentState.validate()) {
                      _autoValidateForm = false;
                      _prepareWebService();
                    } else
                      _autoValidateForm = true;
                  },
                  clr: Colors.red,
                  title: donetxt),
            ),
          )
        ]));
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    SizeManager sm = SizeManager(context);

    Navigator.push(
            context,
            PopupLayout(
                top: sm.scaledHeight(36),
                left: sm.scaledWidth(3),
                right: sm.scaledWidth(3),
                bottom: sm.scaledHeight(30),
                child: PopupContent(
                    content: Scaffold(
                        resizeToAvoidBottomPadding: false, body: widget))))
        .whenComplete(() => setState(() {}));
  }

  Widget _popupBodyShowDetail() {
    return Container(
        child: WorkingDateTime(
      selecteddayList: selecteddayList,
    ));
  }

  void _cityWebData() async {
    WebService.funGetCities().then((value) {
      if (value.message == "success") {
        _cityModel.clear();
        cityList.clear();
        _cityModel.addAll(value.data);
        for (int i = 0; i < _cityModel.length; i++)
          cityList.add(_cityModel[i].city);
        setState(() {});
      }
    });
  }

  void _stateWebData() async {
    WebService.funGetStates().then((value) {
      if (value.message == "success") {
        _stateModel.clear();
        _stateList.clear();
        _stateModel.addAll(value.data);
        for (int i = 0; i < _stateModel.length; i++)
          _stateList.add(_stateModel[i].state);
        setState(() {});
      }
    });
  }

  void _prepareWebService() {
    var website = "";
    for (int _i = 0; _i < webSiteLength; _i++) {
      website = _controller[_i + 15].text + "," + website;
    }
    List<Map> lst = List();
    for (int i = 0; i < selecteddayList.length; i++) {
      var va = selecteddayList[(selecteddayList.keys.toList())[i]].split("-");
      Map<String, String> dayData = Map();
      dayData["business_days"] =
          "${(selecteddayList.keys.toList())[i].toString()}";
      dayData["business_start_hours"] = "${va[0].toString()}";
      dayData["business_end_hours"] = "${va[1].toString()}";
      lst.add(dayData);
    }
    _controller[5].text = lst.toString();
    if (_controller[4].text == "Select Hours" && lst.length == 0) {
      BotToast.showText(text: "Please select time stols!!");
      return;
    }
    addressList.clear();
    for (int i = 0; i < addressLength; i++)
      addressList.add(_controller[i + 6].text);

    Map<String, dynamic> _map = {
      "business_name": _controller[1].text,
      "landline": _controller[3].text,
      "business_phone": _controller[2].text,
      "address": addressList,
      "pincode": _controller[9].text,
      "town_city": _controller[10].text,
      "state_id": _controller[11].text,
      "country_id": '1',
      "location": "${_position.latitude},${_position.longitude}",
      "working_hours": _controller[4].text,
      "website": website.split(","),
      "business_email": _controller[13].text,
      "short_description": _controller[14].text,
      "photo": "${_controller[0].text}",
      "business_hours": lst
    };

    WebService.funUserProfileUpdate(_map).then((value) async {
      if (value.status == 'success') {
        BotToast.showLoading(duration: Duration(seconds: 1));
        await Future.delayed(const Duration(seconds: 1));
        BotToast.showText(text: value.message);
      }
    });
  }

  void getProfileData() async {
    await WebService.getProfileData().then((value) {
      var va = value.data;
      addressList.clear();
      for (int i = 0; i < va.website.length - 1; i++) webSiteLengthPlus();

      addressList.add(va.address1);
      addressList.add(va.address2);
      addressList.add(va.address3);
      addressLength = addressList.length;
      _controller[0].text = va.photo;
      _controller[1].text = va.businessName;
      _controller[2].text = va.businessPhone;
      _controller[3].text = va.landline;
      _controller[4].text = va.workingHours;
      _controller[6].text = addressList[0];
      _controller[7].text = addressList[1];
      _controller[8].text = addressList[2];
      _controller[9].text = va.pincode;
      pinCaller(va.pincode);
      _controller[13].text = va.businessEmail;
      _controller[14].text = va.shortDescription;
      for (int i = 0; i < va.website.length; i++) {
        _controller[i + 15].text = va.website[i];
      }

      print("asasas1 ${va.hours.toList()}");
      var _v = (va.location.split(','));
      setState(() {
        _initPosition = CameraPosition(
            target: LatLng(double.parse(_v[0]), double.parse(_v[1])), zoom: 17);
      });
      for (int _i = 0; _i < va.hours.length; _i++)
        selecteddayList[(va.hours.toList())[_i].day] =
            "${(va.hours.toList())[_i].startHours}-${(va.hours.toList())[_i].endHours}";
    });
  }

  void pinCaller(_val) {
    if (_val.length == 6) {
      WebService.funGetCityByPincode(_controller[9].text).then((value) {
        if (value.data.city == null) {
          BotToast.showText(text: value.message);
          return;
        }
        setState(() {
          _controller[10].text = value.data.city;
          _controller[11].text = value.data.stateName;
          _controller[12].text = "India";
        });
      });
    } else {
      setState(() {
        _controller[10].text = "";
        _controller[11].text = "";
        _controller[12].text = "";
      });
    }
  }
}
