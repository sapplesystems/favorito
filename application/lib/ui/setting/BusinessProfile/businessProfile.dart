import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:Favorito/component/MyGoogleMap.dart';
import 'package:Favorito/component/roundedButton.dart';
import 'package:Favorito/component/txtfieldPostAction.dart';
import 'package:Favorito/model/StateListModel.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHours.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:Favorito/utils/myString.Dart';
import 'package:Favorito/component/txtfieldboundry.dart';
import 'package:Favorito/myCss.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  List<String> error = List();
  ProgressDialog pr;
  int addressLength = 1;
  int webSiteLength = 1;
  List<String> cityList = ["Please Select ..."];
  List<CityModel> _cityModel = [];
  List<String> _stateList = ["Please Select ..."];
  List<StateList> _stateModel = [];
  bool byAppointment = false;
  bool onWhatsapp = false;
  Position _position;
  int stateId = 0;
  int cityId = 0;
  List<String> addressList = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ddCity = GlobalKey<DropdownSearchState<String>>();
  final ddState = GlobalKey<DropdownSearchState<String>>();
  String addOrChangePhoto = '';
  File _image;
  final dd1 = GlobalKey<DropdownSearchState<String>>();

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
    for (int i = 0; i < 16; i++) {
      _controller.add(TextEditingController());
      error.add(null);
    }

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
      _initPosition = CameraPosition(
          target: LatLng(_position.latitude, _position.longitude), zoom: 17);
    }).catchError((e) {
      print(e);
    });
  }

  void webSiteLengthPlus() {
    setState(() {
      webSiteLength++;
      _controller.add(TextEditingController());
    });
  }

  getBusinessProfileData() {
    WebService.funGetBusinessProfileData().then((value) {
      _businessProfileData = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    pr = ProgressDialog(context)..style(message: "Please Wait..");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // actions: [
          //   IconButton(
          //     icon: SvgPicture.asset(
          //       'assets/icon/save.svg',
          //       height: sm.w(6.4),
          //     ),
          //     onPressed: () {},
          //   )
          // ],
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
                  margin: EdgeInsets.only(top: sm.h(10)),
                  child: Builder(
                    builder: (context) => Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            SizedBox(height: sm.h(4)),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: sm.h(5), bottom: sm.h(2)),
                                child: Stack(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: _image == null
                                          ? Image.network(
                                              _controller[0].text,
                                              height: sm.h(20),
                                              width: sm.w(72),
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              height: sm.h(20),
                                              width: sm.w(78),
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                              ))),
                                ])),

                            Container(
                              width: sm.w(40),
                              margin: EdgeInsets.only(bottom: 12.0),
                              child: RoundedButton(
                                  clicker: () {
                                    getImage(ImgSource.Gallery);
                                  },
                                  clr: Colors.red,
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: "Gilroy-Bold",
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1),
                                  title: addOrChangePhoto),
                            ),
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
                            BusinessHours(dd1: dd1),

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
                                              fontFamily: 'Gilroy-Bold',
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
                            SizedBox(height: sm.h(2)),
                            Row(
                              children: [
                                Text('\t\t\tWhere are you located?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Gilroy-Medium',
                                        color: Colors.grey)),
                              ],
                            ),
                            Container(
                              //_controller[6] is allign for this
                              margin: EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: myGrey, width: 1)),
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
                                  sufixClick: () {
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
                                error: error[9],
                                keyboardSet: TextInputType.number,
                                hint: "Enter Pincode",
                                myOnChanged: (_val) {
                                  pinCaller(_val);
                                }),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DropdownSearch<String>(
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                mode: Mode.MENU,
                                key: ddCity,
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
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                mode: Mode.MENU,
                                key: ddState,
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
                                  sufixClick: () {
                                    webSiteLengthPlus();
                                  }),
                          ]),
                        )),
                  ),
                ),
                Positioned(
                    top: sm.h(4),
                    left: sm.w(8),
                    right: sm.w(8),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: sm.w(0), vertical: sm.h(3)),
                          child: Column(children: [
                            Text(
                              "Your Business ID",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  fontFamily: 'Gilroy-Medium'),
                            ),
                            SizedBox(height: 4),
                            Text(
                              business_id,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 1.2,
                                  fontFamily: 'Gilroy-Medium'),
                            )
                          ])),
                    ))
              ])),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: sm.w(60),
              margin: EdgeInsets.only(bottom: 8.0),
              child: RoundedButton(
                  clicker: () {
                    if (_formKey.currentState.validate()) _prepareWebService();
                  },
                  clr: Colors.red,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Gilroy-Bold",
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5),
                  title: donetxt),
            ),
          )
        ]));
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

    _controller[5].text = lst.toString();
    // if (_controller[4].text == "Select Hours" && lst.length == 0) {
    //   BotToast.showText(text: "Please select time stols!!");
    //   return;
    // }
    addressList.clear();
    for (int i = 0; i < addressLength; i++)
      addressList.add(_controller[i + 6].text);

    Map<String, dynamic> _map = {
      "business_name": _controller[1].text,
      "landline": _controller[3].text,
      "business_phone": _controller[2].text,
      "address": addressList,
      "postal_code": _controller[9].text,
      "town_city": _controller[10].text,
      "state_id": _controller[11].text,
      "country_id": '1',
      "location": "${_position.latitude},${_position.longitude}",
      "working_hours": dd1.currentState.getSelectedItem,
      "website": website.split(","),
      "business_email": _controller[13].text,
      "short_description": _controller[14].text,
      "photo": "${_controller[0].text}",
      "business_hours": lst
    };
    print("_map:${_map.toString()}");
    WebService.funUserProfileUpdate(_map, context).then((value) async {
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
      print("datam${value.data.toString()}");
      addressList.clear();
      for (int i = 0; i < va.website.length; i++) {
        va.website[i] = va.website[i].trim();
        if (va.website[i].length > 4) {
          webSiteLengthPlus();
        } else
          va.website.removeAt(i);
      }

      addressList.add(va.address1 ?? '');
      addressList.add(va.address2 ?? '');
      addressList.add(va.address3 ?? '');
      addressLength = addressList.length;
      _controller[0].text = va.photo ?? '';
      setState(() {
        addOrChangePhoto = va.photo == null ? 'add photo' : 'change photo';
      });
      _controller[1].text = va.businessName ?? '';
      _controller[2].text = va.businessPhone ?? '';
      _controller[3].text = va.landline ?? "";
      _controller[4].text = va.workingHours;
      _controller[6].text = addressList[0] ?? '';
      _controller[7].text = addressList[1] ?? '';
      _controller[8].text = addressList[2] ?? '';
      _controller[9].text = va.postalCode ?? '';

      dd1.currentState.changeSelectedItem(va.workingHours);

      pinCaller(va.postalCode);
      _controller[13].text = va.businessEmail;
      _controller[14].text = va.shortDescription;
      for (int i = 0, m = -1; i < va.website.length; i++) {
        if (va.website[i].length > 4) {
          m++;
          _controller[m + 15].text = va.website[i];
        }
      }

      print("asasas1 ${va.hours.toList()}");
      var _v = (va.location.split(','));
      setState(() {
        _initPosition = CameraPosition(
            target: LatLng(double.parse(_v[0]), double.parse(_v[1])), zoom: 17);
      });
    });
  }

  void pinCaller(String _val) async {
    if (_val.length == 6) {
      pr.show();
      await WebService.funGetCityByPincode({"pincode": _val}).then((value) {
        pr.hide();
        if (value.data.city == null) {
          error[9] = value.message;
          return;
        } else {
          error[9] = null;
        }
        ddCity.currentState.changeSelectedItem(value.data.city);
        ddState.currentState.changeSelectedItem(value.data.stateName);
        setState(() => _controller[12].text = "India");
      });
    } else {
      setState(() {
        _controller[10].text = "";
        _controller[11].text = "";
        // _controller[12].text = "";
      });
    }
  }
}
