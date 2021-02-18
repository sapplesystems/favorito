import 'dart:async';
import 'dart:io';
import 'package:Favorito/model/StateListModel.dart';
import 'package:Favorito/model/business/BusinessProfileModel.dart';
import 'package:Favorito/model/notification/CityListModel.dart';
import 'package:Favorito/network/webservices.dart';
import 'package:Favorito/utils/myColors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class BusinessProfileProvider extends ChangeNotifier {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  CameraPosition initPosition;
  Completer<GoogleMapController> GMapcontroller = Completer();
  Set<Marker> marker = {};
  List<TextEditingController> controller = List();

  ScrollController listviewController = ScrollController();
  List<FocusNode> focusnode = List();
  List<String> error = List();
  bool firstTime = true;
  ProgressDialog pr;
  int addressLength = 1;
  int webSiteLength = 1;
  List<String> cityList = ["Please Select ..."];
  List<CityModel> _cityModel = [];
  List<String> stateList = ["Please Select ..."];
  List<StateList> stateModel = [];
  bool byAppointment = false;
  bool onWhatsapp = false;
  Position currentPosition;
  int stateId = 0;
  int cityId = 0;
  List<String> addressList = [];
  BuildContext context;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ddCity = GlobalKey<DropdownSearchState<String>>();
  final ddState = GlobalKey<DropdownSearchState<String>>();
  String addOrChangePhoto = 'Add Photo';
  final dd1 = GlobalKey<DropdownSearchState<String>>();
  List<String> titleList = ["", "Business Name", "Business Phone", "LandLine"];
  List<bool> validateList = [false, true, true, false];
  List<TextInputType> inputType = [
    TextInputType.name,
    TextInputType.name,
    TextInputType.number,
    TextInputType.number
  ];
  bool _showDone = false;
  needSave(val) {
    _showDone = val;
    notifyListeners();
  }

  getNeedSave() => _showDone;

  BusinessProfileProvider() {
    _getCurrentLocation();
    for (int i = 0; i < 18; i++) {
      controller.add(TextEditingController());
      focusnode.add(FocusNode());
      error.add(null);
    }
    getProfileData(false);
    _cityWebData();
    _stateWebData();
  }

  void _cityWebData() async {
    WebService.funGetCities().then((value) {
      if (value.message == "success") {
        _cityModel.clear();
        cityList.clear();
        _cityModel.addAll(value.data);
        for (int i = 0; i < _cityModel?.length; i++)
          cityList.add(_cityModel[i].city);
      }
    });
  }

  void _stateWebData() async {
    WebService.funGetStates().then((value) {
      if (value.message == "success") {
        stateModel.clear();
        stateList.clear();
        stateModel.addAll(value.data);
        for (int i = 0; i < stateModel?.length; i++)
          stateList.add(stateModel[i].state);
      }
    });
  }

  prepareWebService() {
    var website = '';
    for (int _i = 0; _i < webSiteLength; _i++) {
      if (controller[_i + 15].text.isEmpty) {
      } else {
        website = controller[_i + 15].text?.trim() + "," + website;
      }
    }
    List<Map> lst = List();

    controller[5].text = lst.toString();
    // if (_controller[4].text == "Select Hours" && lst.length == 0) {
    //   BotToast.showText(text: "Please select time stols!!");
    //   return;
    // }
    addressList.clear();
    for (int i = 0; i < addressLength; i++)
      addressList.add(controller[i + 6].text);
    String positions;
    try {
      _getCurrentLocation();
      positions = currentPosition?.latitude.toString() +
          ',' +
          currentPosition?.longitude.toString();
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
      "working_hours": dd1.currentState.getSelectedItem,
      "website": website?.contains(',') ? website.trim()?.split(",") : null,
      "business_email": controller[13].text,
      "short_description": controller[14].text,
      "photo": "${controller[0].text}",
    };
    print("_map:${map.toString()}");
    WebService.funUserProfileUpdate(map).then((value) async {
      if (value.status == 'success') {
        BotToast.showLoading(duration: Duration(seconds: 1));
        await Future.delayed(const Duration(seconds: 1));
        BotToast.showText(text: value.message);
      }
    });
  }

  getProfileData(bool val) async {
    if (val)
      try {
        pr?.show()?.timeout(Duration(seconds: 10));
      } catch (e) {
        print(e.toString);
      }
    await WebService.getProfileData().then((value) {
      if (val)
        try {
          pr?.hide()?.timeout(Duration(seconds: 10));
        } catch (e) {
          print(e.toString);
        }
      if (pr.isShowing()) pr.hide();
      var va = value?.data;
      addressList?.clear();
      if (va?.website != null)
        for (int i = 0; i < va.website.length; i++) {
          print("_v1:${controller.length}");
          if (va.website[i].trim().isNotEmpty &&
              va.website[i].characters.length > 2) {
            controller[15 + i].text = va.website[0];
            if (va.website.length < webSiteLength) webSiteLengthPlus();
          }
        }
      controller[1].text = va.businessName ?? '';
      controller[2].text = va.businessPhone ?? '';
      controller[3].text = va.landline ?? "";

      addressList.add(va.address1 ?? '');
      addressList.add(va.address2 ?? '');
      addressList.add(va.address3 ?? '');
      addressLength = addressList?.length;

      if (va?.photo != null) {
        controller[0].text = va.photo;
        addOrChangePhoto = 'change photo';
      }
      print("va.businessName${va.businessName}");
      controller[2].text = va.businessPhone ?? '';
      controller[3].text = va.landline ?? "";
      controller[4].text = va.workingHours;

      controller[6].text = addressList[0] ?? '';
      controller[7].text = addressList[1] ?? '';
      controller[8].text = addressList[2] ?? '';
      controller[9].text = va.postalCode ?? '';

      dd1?.currentState?.changeSelectedItem(va?.workingHours ?? "");

      pinCaller(va.postalCode);
      controller[13].text = va.businessEmail;
      controller[14].text = va.shortDescription;

      if (va.location != null) {
        var _v = (va.location?.split(','));
        initPosition = CameraPosition(
            target: LatLng(double.parse(_v[0]), double.parse(_v[1])), zoom: 17);
      }
      controller[4].text = va.workingHours;
      // notifyListeners();
      if (controller[4].text == "Select Hours" ||
          controller[4].text == 'Select Hours') {
        // Provider.of<BusinessHoursProvider>(context, listen: false).getData();
      }

      listviewController.animateTo(listviewController.position.minScrollExtent,
          curve: Curves.easeOut, duration: const Duration(milliseconds: 5));
      notifyListeners();
      return value;
    });
  }

  void pinCaller(String _val) async {
    if (_val?.length == 6) {
      await WebService.funGetCityByPincode({"pincode": _val}).then((value) {
        if (value.data.city == null) {
          error[9] = value.message;
          return;
        } else
          error[9] = null;

        ddCity?.currentState?.changeSelectedItem(value.data.city);
        ddState?.currentState?.changeSelectedItem(value.data.stateName);
        controller[12].text = "India";
      });
    } else {
      controller[10].text = "";
      controller[11].text = "";
      error[9] = null;
    }
    notifyListeners();
    needSave(false);
  }

  setContext(BuildContext context) {
    this.context = context;
    pr = ProgressDialog(context)..style(message: "Please Wait..");
  }

  void webSiteLengthPlus() {
    webSiteLength++;
    print("_v:${webSiteLength}");
    controller.add(TextEditingController());
  }

  getBusinessProfileData() {
    WebService.funGetBusinessProfileData().then((value) {
      _businessProfileData = value;
    });
  }

  _getCurrentLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      this.currentPosition = position;
      initPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
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

    File croppedFile = await ImageCropper.cropImage(
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
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0));
    image = croppedFile;
    pr.show();
    await WebService.profileImageUpdate(image).then((value) {
      if (value.status == "success") {
        pr.hide();
        controller[0].text = value.data[0].photo;
        addOrChangePhoto = 'change photo';
        notifyListeners();
      }
    });
  }

  allClear() {
    BusinessProfileModel _temp = BusinessProfileModel();
    _businessProfileData = _temp;
    controller.forEach((e) {
      e.text = '';
    });
  }
}
