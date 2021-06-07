import 'dart:async';
import 'dart:io';
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
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class BusinessProfileProvider extends ChangeNotifier {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  BusinessProfileModel _businessProfileData = BusinessProfileModel();
  CameraPosition _initPosition;
  Completer<GoogleMapController> GMapcontroller = Completer();
  Set<Marker> _marker = {};
  List<TextEditingController> controller = [];
  ScrollController listviewController = ScrollController();
  List<FocusNode> focusnode = [];
  List<String> error = [];
  bool firstTime = true;
  ProgressDialog pr;
  int addressLength = 1;
  List<String> websites = [];
  List<String> cityList = ["Please Select ..."];
  List<CityModel> _cityModel = [];
  List<String> stateList = ["Please Select ..."];
  List<StateList> stateModel = [];
  bool byAppointment = false;
  bool onWhatsapp = false;
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
    for (int i = 0; i < 15; i++) {
      controller.add(TextEditingController());
      focusnode.add(FocusNode());
      error.add(null);
    }
    getWebSiteList();
    getProfileData(false);
    getBusinessProfileData();
    _cityWebData();
    _stateWebData();
  }

  void _cityWebData() async {
    await WebService.funGetCities().then((value) {
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
      "working_hours": dd1.currentState.getSelectedItem,
      "website": websites,
      "business_email": controller[13].text,
      "short_description": controller[14].text,
      "photo": "${controller[0].text}",
    };
    print("_map:${map.toString()}");
    pr.show().timeout(Duration(seconds: 5));
    await WebService.funUserProfileUpdate(map).then((value) async {
      pr.hide();
      Provider.of<SettingProvider>(context, listen: false).getProfileImage();
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
        } catch (e) {}
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

      if (va.location != null) {
        var _v = (va.location?.split(','));
        setPosition(_v);
      }
      addressList?.clear();

      // for (int i = 0; i < va.website?.length; i++)
      //   if (va?.website[i] == '') va?.website.removeAt(i);
      // webSiteLength = va.website.length;
      // print("sdsd${va.website.length}");
      // for (int i = 0; i < va.website?.length; i++) {
      //   controller[15 + i].text = va.website[0];
      // }
      notifyListeners();
      // if (va?.website != null)
      //   for (int i = 0; i < va.website.length; i++) {
      //     print("_v1:${controller.length}");
      //     if (va.website[i].trim().isNotEmpty &&
      //         va.website[i].characters.length > 2) {
      //       controller[15 + i].text = va.website[0];
      //       if (va.website.length < webSiteLength) webSiteLengthPlus();
      //     }
      //   }
      controller[1].text = va.businessName ?? '';

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

      dd1?.currentState?.changeSelectedItem(va?.workingHours ?? "");

      pinCaller(va.postalCode, false);
      controller[13].text = va.businessEmail;
      controller[14].text = va.shortDescription;

      controller[4].text = va.workingHours;
      // notifyListeners();
      if (controller[4].text == "Select Hours" ||
          controller[4].text == 'Select Hours') {
        // Provider.of<BusinessHoursProvider>(context, listen: false).getData();
      }
      try {
        listviewController.animateTo(
            listviewController?.position?.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 40));

        dd1?.currentState?.changeSelectedItem(va.workingHours ?? '');
        Provider.of<BusinessHoursProvider>(context, listen: false)
            .setController(va.workingHours);
      } catch (e) {} finally {
        notifyListeners();
      }
      return value;
    });
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

        ddCity?.currentState?.changeSelectedItem(value.data.city);
        ddState?.currentState?.changeSelectedItem(value.data.stateName);
        controller[12].text = "India";
      });
    } else {
      controller[10].text = "";
      controller[11].text = "";
      error[9] = null;
    }
    needSave(_val1);
  }

  setContext(BuildContext context) {
    this.context = context;
    pr = ProgressDialog(context)
      ..style(
          message: 'Please wait...',
          borderRadius: 8.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 8.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: myRed, fontSize: 19.0, fontWeight: FontWeight.w600));
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
      // websiteList.addAll(value.data ?? [' ']);
      // if (websiteList.length == 0) websiteList.add(' ');
      try {
        if ((value?.data?.length ?? 0) > 0) {
          for (int _i = 0; _i < value.data.length; _i++) {
            if (!websites.contains(value.data[_i])) {
              websites.add(value.data[_i]);
              controller.add(TextEditingController());
              controller[controller.length - 1].text = websites[_i];
            }
          }
        } else {
          if (controller.length < 16) {
            controller.add(TextEditingController());
          }

          notifyListeners();
        }
      } catch (e) {
        print("Website Error:${e.toString()}");
      }
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

  allClear() {
    BusinessProfileModel _temp = BusinessProfileModel();
    _businessProfileData = _temp;

    controller.forEach((e) {
      e.text = '';
    });
    notifyListeners();
  }

  void setPosition(List<String> _v) {
    Marker _val = Marker(
      markerId: MarkerId('new Address'),
      position: LatLng(double.parse(_v[0]), double.parse(_v[1])),
    );

    _initPosition = CameraPosition(target: _val.position, zoom: 17);
    _marker.clear();
    _marker.add(_val);
    notifyListeners();
  }

  CameraPosition getPosition() => _initPosition;
  getMarget() => _marker;

  willPop(ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Please confirm"),
          content: Text('do you save data?'),
          actions: [
            new FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  if (formKey.currentState.validate()) prepareWebService();
                }),
            new FlatButton(
              child: const Text("Cancel"),
              onPressed: () async {
                getProfileData(true);
              },
            ),
            new FlatButton(
              child: const Text(''),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
    notifyListeners();
    // v.needSave(false);
    Navigator.pop(context);
  }
}
