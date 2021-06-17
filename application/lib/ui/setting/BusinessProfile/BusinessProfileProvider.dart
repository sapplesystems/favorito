import 'dart:async';
import 'dart:io';
import 'package:Favorito/Provider/BaseProvider.dart';
import 'package:Favorito/model/StateListModel.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessHoursProvider.dart';
import 'package:Favorito/ui/setting/setting/SettingProvider.dart';

import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class BusinessProfileProvider extends BaseProvider {
  String _businessId;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  CameraPosition _initPosition;
  // Completer<GoogleMapController> gMapcontroller = Completer();
  Set<Marker> _marker = {};
  List<TextEditingController> controller = [];
  ScrollController listviewController = ScrollController();
  List<FocusNode> focusnode = [];
  List<String> error = [];
  bool firstTime = true;
  bool loading = false;
  int addressLength = 1;
  List<String> websites = [];
  String hoursTitle1 = 'Existing Slots';
  String hoursTitle2 = 'Add New Slots';
  bool byAppointment = false;
  bool onWhatsapp = false;
  int stateId = 0;
  int cityId = 0;
  List<String> addressList = [];
  BuildContext context;
  String addOrChangePhoto = 'Add Photo';
  String businessName;
  final dd1 = GlobalKey<DropdownSearchState<String>>();
  List<String> titleList = ["", "Business Name", "Business Phone", "LandLine"];
  List<bool> validateList = [false, true, true, false];
  String workingItem;
  List<TextInputType> inputType = [
    TextInputType.name,
    TextInputType.name,
    TextInputType.number,
    TextInputType.number
  ];
  bool _showDone = false;

  List<Hours> daysHours = [];

  BusinessProfileProvider() {
    _getCurrentLocation();
    for (int i = 0; i < 16; i++) {
      controller.add(TextEditingController());
      focusnode.add(FocusNode());
      error.add(null);
    }
    getBusinessProfileData();
    BusinessHoursAdd();
  }

//hours codde start

  bool _isEdit = false;

  MaterialLocalizations localizations;

  BoxDecoration bdcf = BoxDecoration(
      border: Border.all(width: 1.0, color: myGrey),
      borderRadius: BorderRadius.all(Radius.circular(5.0)));
  BoxDecoration bdct = BoxDecoration(
      color: myRed,
      border: Border.all(width: 1.0, color: myRed),
      borderRadius: BorderRadius.all(Radius.circular(5.0)));
  BoxDecoration bdctt = BoxDecoration(
      color: myGrey,
      border: Border.all(width: 1.0, color: myRed),
      borderRadius: BorderRadius.all(Radius.circular(5.0)));
  String text;
  List<String> daylist = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  Map<String, String> selecteddayList = {};
  String startTime = 'Start Time';
  String endTime = 'End Time';
  List<int> renge = [];

  BusinessHoursAdd() {
    for (var _d in daylist) {
      print("this is called 1");
      daysHours.add(Hours(
          day: _d, open: false, selected: false, startHours: "", endHours: ""));
    }

    getData();
  }

  setText(String _val) {
    print("_val:$_val");
    text = _val ?? "";
    notifyListeners();
    getData();
  }

  clear() {
    selecteddayList.clear();
    text = '';
    for (int _i = 0; _i < daysHours.length; _i++) {
      daysHours[_i].open = false;
      daysHours[_i].selected = false;
    }
    notifyListeners();
  }

  String getSelectedItem() => text;

  getData() async {
    await WebService.funGetBusinessWorkingHours().then((value) {
      if (value.status == 'success') {
        selecteddayList.clear();
        for (int _i = 0; _i < value.data.length; _i++) {
          selecteddayList[(value.data.toList())[_i].day] =
              "${(value.data.toList())[_i].startHours}-${(value.data.toList())[_i].endHours}";
          if ((value.data.toList())[_i].day.contains('-')) {
            int _j = daylist
                .indexOf(((value.data.toList()[_i]).day).split('-')[0].trim());
            int _k = daylist
                .indexOf(((value.data.toList()[_i]).day).split('-')[1].trim());
            for (int _m = _j; _m <= _k; _m++) {
              daysHours[_m].day = daylist[_m];
              daysHours[_m].startHours = (value.data.toList())[_i].startHours;
              daysHours[_m].endHours = (value.data.toList())[_i].endHours;
              daysHours[_m].open = true;
            }
          } else {
            int _a = daylist.indexOf((value.data.toList())[_i].day);

            try {
              daysHours[_a].day = daylist[_a];
              daysHours[_a].startHours = (value.data.toList())[_i].startHours;
              daysHours[_a].endHours = (value.data.toList())[_i].endHours;
              daysHours[_a].open = true;
            } catch (e) {
              print("Error1:${e.toString()}");
            }
          }
        }
      }
      notifyListeners();
    });
  }

  SetContexts(BuildContext context) {
    this.context = context;
  }

  popupClosed() {
    renge.clear();
    for (int i = 0; i < daysHours.length; i++) {
      daysHours[i].selected = false;
      daysHours[i].open = false;
    }
    startTime = 'Start Time';
    endTime = 'End Time';
    getData();
    notifyListeners();
  }

  pickDate(val) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child);
      },
    ).then((value) {
      var s = localizations
          .formatTimeOfDay(value, alwaysUse24HourFormat: true)
          .toString();
      if (val)
        startTime = s.substring(0, 5);
      else
        endTime = s.substring(0, 5);
      notifyListeners();
    });
  }

  setData(Map _map) async {
    print("_map2:${_map.toString()}");
    await WebService.funSetBusinessWorkingHours(_map).then((value) {
      if (value.status == 'success') {
        selecteddayList.clear();
        for (int _i = 0; _i < value.data.length; _i++)
          selecteddayList[(value.data.toList())[_i].day] =
              "${(value.data.toList())[_i].startHours}-${(value.data.toList())[_i].endHours}";
      }
      daysHours.forEach((e) {
        e.open = false;
      });
      getData();
      Navigator.pop(context);
    });
  }

  prepareData() {
    if (startTime == 'Start Time' ||
        endTime == 'End Time' ||
        startTime.isEmpty ||
        endTime.isEmpty) return;
    List<Map<String, String>> h = [];

    for (int i = 0; i < daysHours.length; i++) {
      Map<String, String> m = Map();

      m['business_days'] = daysHours[i].day;
      if (_isEdit) {
        if (daysHours[i].open) {
          if (daysHours[i].selected) {
            m['business_start_hours'] = startTime;
            m['business_end_hours'] = endTime;
          } else {
            m['business_start_hours'] =
                daysHours[i].startHours.trim().substring(0, 5);
            m['business_end_hours'] =
                daysHours[i].endHours.trim().substring(0, 5);
          }
          h.add(m);
        }
      } else {
        if (daysHours[i].selected) {
          m['business_start_hours'] = startTime;
          m['business_end_hours'] = endTime;
          h.add(m);
        } else if (daysHours[i].open) {
          m['business_start_hours'] = daysHours[i].startHours;
          m['business_end_hours'] = daysHours[i].endHours;
          h.add(m);
        }
      }
    }
    Map _map = {"business_hours": h};
    print("_map1:${_map.toString()}");
    setData(_map);
  }

  refresh() => notifyListeners();
  setMod(_val) {
    _isEdit = _val;
    notifyListeners();
  }

  bool getMod() => _isEdit;

  selectDay(int _index) {
    print("$_isEdit $_index");
    print("${daysHours[_index].open}");
    print("${daysHours.toString()}");

    if (_isEdit) {
      if (renge.contains(_index) && daysHours[_index].open) {
        daysHours[_index].selected = !daysHours[_index].selected;
        if (!daysHours[_index].selected) {
          print("doing off");
          daysHours[_index].open = false;
        }
        startTime = daysHours[_index].startHours.trim().substring(0, 5);
        endTime = daysHours[_index].endHours.trim().substring(0, 5);
      } else {
        daysHours[_index].selected = true;
        daysHours[_index].startHours = startTime;
        daysHours[_index].endHours = endTime;
        daysHours[_index].open = true;
      }
    } else if (!_isEdit) {
      if (!daysHours[_index].open) {
        daysHours[_index].selected = !daysHours[_index].selected;
      }
    }
    notifyListeners();
  }

  allClear() async {
    if (preferences.getString('businessId') != _businessId) {
      _businessId = preferences.getString('businessId');
      selecteddayList.clear();
      notifyListeners();
    }
  }

//hours codde end

  needSave(val) {
    _showDone = val;
    notifyListeners();
  }

  getNeedSave() => _showDone;

  prepareWebService() async {
    for (int _i = 15; _i < controller.length; _i++) {
      if (controller[_i].text != null &&
          !websites.contains(controller[_i].text.trim())) {
        websites.add(controller[_i].text.trim());
      }
    }
    List<Map> lst = List();

    controller[5].text = lst.toString();
    addressList.clear();
    for (int i = 0; i < addressLength; i++)
      addressList.add(controller[i + 6].text);
    String positions;
    try {
      _getCurrentLocation();
      positions = _initPosition?.target?.latitude.toString() +
          ',' +
          _initPosition?.target?.longitude.toString();
      print("positions:${positions}");
    } catch (e) {
      BotToast.showText(text: 'To continue turn on location services!');
      return;
    }
    Map<String, dynamic> map = {
      "business_name": controller[1].text,
      "landline": controller[3].text,
      "business_phone": controller[2].text,
      "address": addressList,
      "postal_code": controller[9].text,
      "town_city": controller[10].text,
      "state_id": controller[11].text,
      "country_id": '1',
      "location": positions ?? "",
      // "working_hours": dd1?.currentState?.getSelectedItem ?? "",
      "working_hours": text ?? "",
      "website": websites,
      "business_email": controller[13].text,
      "short_description": controller[14].text,
      "photo": "${controller[0].text}",
    };
    print("_map:${map.toString()}");
    await WebService.funUserProfileUpdate(map).then((value) async {
      // Provider.of<SettingProvider>(context, listen: false).getProfileImage();
      if (value.status == 'success') {
        await Future.delayed(const Duration(seconds: 1));
        needSave(false);
        BotToast.showText(text: value.message);
 
        try {
          listviewController.animateTo(
              listviewController?.position?.minScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(microseconds: 1));
          FocusScope.of(context).unfocus();
        } catch (e) {
          getProfileData(context);
        }
        
      }
    });
  }

  getProfileData(context) async {
    loading = true;

    await WebService.getProfileData().then((value) {
      var va = value?.data;
      loading = false;
      if (va.location != null) {
        var _v = (va.location?.split(','));
        setPosition(_v);
      }
      addressList?.clear();
      businessName = va.businessName ?? '';
      controller[1].text = businessName;

      controller[2].text = va.businessPhone ?? '';
      controller[3].text = va.landline ?? "";

      addressList.add(va.address1 ?? '');
      addressList.add(va.address2 ?? '');
      addressList.add(va.address3 ?? '');
      addressLength = addressList?.length;

      if (va?.photo != null) {
        controller[0].text = va.photo;
        addOrChangePhoto = 'Change Photo';
      }
      print("va.businessName${va.businessName}");
      controller[2].text = va.businessPhone ?? '';
      controller[3].text = va.landline ?? "";
      controller[4].text = va.workingHours;

      controller[6].text = addressList[0] ?? '';
      controller[7].text = addressList[1] ?? '';
      controller[8].text = addressList[2] ?? '';
      controller[9].text = va.postalCode ?? '';
      workingItem = va?.workingHours ?? "";
      pinCaller(va.postalCode, false);
      controller[13].text = va.businessEmail;
      controller[14].text = va.shortDescription;

      controller[4].text = va.workingHours;
      // notifyListeners();
      if (controller[4].text == "Select Hours" ||
          controller[4].text == 'Select Hours') {}
      try {
        listviewController.animateTo(
            listviewController?.position?.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 40));
      } catch (e) {}
      try {
        print("_controller.text1;${va.workingHours}");
        // dd1?.currentState?.changeSelectedItem(va.workingHours ?? '');
        text = va.workingHours;
        if (va.workingHours == "Select Hours") getData();
      } catch (e) {
        print("_controller.textError:${e.toString()}");
      } finally {
        notifyListeners();
      }
    });
    // if (Provider.of<BusinessHoursProvider>(context, listen: false).text !=
    //     workingItem) getProfileData(context);
    getWebSiteList();
  }

  void pinCaller(String _val, bool _val1) async {
    if (_val?.length == 6) {
      await WebService.funGetCityByPincode({"pincode": _val}).then((value) {
        if (value.data.city == null) {
          error[9] = value.message;
          return;
        } else
          error[9] = null;
        controller[10].text = value.data.city;
        controller[11].text = value.data.stateName;
        controller[12].text = "India";
      });
    } else {
      controller[10].text = "";
      controller[11].text = "";
      error[9] = null;
    }
    needSave(_val1);
  }

  void webSiteLengthPlus(int i) {
    if (controller[i].text.isNotEmpty && (i == controller.length - 1))
      controller.add(TextEditingController());
    notifyListeners();
  }

  getBusinessProfileData() async {
    await WebService.funGetBusinessProfileData().then((value) {
      _businessProfileData = value;
      notifyListeners();
    });
  }

  getWebSiteList() async {
    await WebService.websitesList().then((value) {
      controller[15].text = value.data.isNotEmpty ? value.data.first : "";
      // notifyListeners();
    });
  }

  _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setPosition(
          [position.latitude.toString(), position.longitude.toString()]);
    }).catchError((e) {
      print(e);
    });
    notifyListeners();
  }

  Future getImage(ImgSource source) async {
    File image;
    image = await ImagePickerGC.pickImage(
        context: context,
        source: source,
        imageQuality: 10,
        cameraIcon: Icon(Icons.add, color: Colors.red));

    await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: myRed,
                statusBarColor: myBackGround,
                cropGridColor: myBackGround,
                backgroundColor: myBackGround,
                cropFrameColor: myBackGround,
                dimmedLayerColor: myBackGround,
                cropGridColumnCount: 8,
                activeControlsWidgetColor: myBackGround,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: true),
            iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0))
        .then((value) async {
      if (value != null) {
        image = value;
        await WebService.profileImageUpdate(image, context).then((value) {
          if (value.status == "success") {
            controller[0].text = value.data[0].photo;
            addOrChangePhoto = 'Change Photo';
            notifyListeners();
            Provider.of<SettingProvider>(context, listen: false)
                .getProfileImage();
          }
        });
      }
    });

    notifyListeners();
  }

  void setPosition(List<String> _v) {
    Marker _val = Marker(
      markerId: MarkerId('new Address'),
      position: LatLng(
          double.parse((_v[0] == "null" || _v[0] == 'null') ? "0.0" : _v[0]),
          double.parse((_v[1] == "null" || _v[1] == 'null') ? "0.0" : _v[1])),
    );

    _initPosition = CameraPosition(target: _val.position, zoom: 17);
    _marker.clear();
    _marker.add(_val);
    notifyListeners();
  }

  CameraPosition getPosition() => _initPosition;
  getMarget() => _marker;
}
