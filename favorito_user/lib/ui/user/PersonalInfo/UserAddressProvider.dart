import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:favorito_user/model/CityStateModel.dart';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/Acces.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:provider/provider.dart';
import '../../../utils/Extentions.dart';

class UserAddressProvider extends ChangeNotifier {
  String _profileImage;
  AddressListModel addressListModel = AddressListModel();
  String mode = 'Add';
  String _city;
  String _state;
  String _editId;
  List<CityStateData> _stateList = [];
  CityStateData _selectedState = CityStateData(id: 0, state: '');
  List title = ['address', 'landmark.', 'pincode', 'city', 'state'];
  List prefix = ['address', 'address', 'pincode', 'address', 'address'];
  List<Acces> acces = [];
  String _addresstype = 'Home';
  List<String> fList = ["Home", "Office", "Hotel", "Others"];
  var id;
  UserAddressProvider() {
    for (int i = 0; i < 5; i++) acces.add(Acces());
    getAddress();
    getUserImage();
    // getAllState();
  }

  String getAddresstype() => _addresstype;
  setAddresstype(String _va) {
    _addresstype = _va;
    notifyListeners();
  }

  getEditId() => _editId;
  setEditId(String _id) {
    _editId = _id;
    int _va;
    if (_id != null) {
      for (int i = 0; i < addressListModel.data.addresses.length; i++) {
        if (addressListModel.data.addresses[i].id.toString().trim() == _id) {
          _va = i;
        }
      }
      acces[0].controller.text = addressListModel.data.addresses[_va].address;
      acces[1].controller.text = addressListModel.data.addresses[_va].landmark;
      acces[2].controller.text = addressListModel.data.addresses[_va].pincode;
      acces[3].controller.text = addressListModel.data.addresses[_va].city;
      acces[4].controller.text = addressListModel.data.addresses[_va].state;
      _addresstype = addressListModel.data.addresses[_va].addressType;
      mode = 'Edit';
    } else {
      mode = 'Add';
      for (var v in acces) {
        v.controller.text = '';
        v.error = null;
      }
    }

    notifyListeners();
  }

  void checkPin() async {
    await APIManager.checkPostalCode(
            {"pincode": acces[2].controller.text}, RIKeys.josKeys6)
        .then((value) {
      if (value.data.stateName == null)
        acces[2].error = value.message;
      else {
        acces[2].error = null;
        acces[3].controller.text = value.data.city;
        acces[4].controller.text = value.data.stateName;
      }
      notifyListeners();
    });
  }

  void SubmitAddress() async {
    if (acces[0].controller.text.trim().length == 0) {
      acces[0].error = 'field is required';
      notifyListeners();
      return;
    } else {
      acces[0].error = null;
      notifyListeners();
    }

    if (acces[1].controller.text.trim().length == 0) {
      acces[1].error = 'field is required';
      notifyListeners();
      return;
    } else {
      acces[1].error = null;
      notifyListeners();
    }
    if (acces[2].controller.text.trim().length == 0) {
      acces[2].error = 'field is required';
      notifyListeners();
      return;
    } else if (acces[2].controller.text.trim().length != 6) {
      acces[2].error = 'Incomplete OTP';
      notifyListeners();
      return;
    } else {
      checkPin();
    }
    Map _map = {
      'city': acces[3].controller.text,
      'state': acces[4].controller.text,
      'pincode': acces[2].controller.text,
      'country': 'India',
      'landmark': acces[1].controller.text,
      'address': acces[0].controller.text,
      'address_type': _addresstype
    };
    Map _map2 = {
      'address_id': _editId,
      'city': acces[3].controller.text,
      'state': acces[4].controller.text,
      'pincode': acces[2].controller.text,
      'country': 'India',
      'landmark': acces[1].controller.text,
      'address': acces[0].controller.text,
      'address_type': _addresstype
    };
    await APIManager.modifyAddress(
            mode == 'Add' ? _map : _map2, RIKeys.josKeys6)
        .then((value) {
      if (value.status == "success") {
        for (var v in acces) {
          v.controller.text = '';
          v.error = null;
        }
        BotToast.showText(text: value.message);
      } else
        BotToast.showText(text: value.message);
      notifyListeners();
    });
  }

  getStateList() => _stateList;
  CityStateData getSelectedStateIndex() {
    // CityStateData _val;
    // for (int i = 0; i < _stateList.length; i++) {
    // if (_stateList[i].id == _selectedState) {
    //   _val = _stateList[i];
    // }
    // }

    return _selectedState;
    // if (_selectedStateId != 0)
    //   _stateList.where((element) => element.id == _selectedStateId);
  }

  setSelectedStateIndex(CityStateData _val) {
    _selectedState = _val;
    notifyListeners();
  }

  getAddress() async {
    await APIManager.getAddress().then((value) {
      if (value.status == 'success') {
        addressListModel = value;
        notifyListeners();
      }
    });
  }

  String get city => _city ?? '';
  String get state => _state ?? '';
  seSelectedAddress(int index) async {
    await APIManager.changeAddress(
        {'default_address_id': this.addressListModel.data.addresses[index].id},
        RIKeys.josKeys3);

    for (int _i = 0; _i < this.addressListModel.data.addresses.length; _i++) {
      this.addressListModel.data.addresses[_i].defaultAddress =
          (index == _i) ? 1 : 0;
    }

    notifyListeners();
  }

  String getSelectedAddress() {
    Addresses _v;
    var va;
    var addressLength = this?.addressListModel?.data?.addresses?.length ?? 0;
    for (int i = 0; i < addressLength; i++) {
      if (this?.addressListModel?.data?.addresses[i]?.defaultAddress == 1) {
        _v = this?.addressListModel?.data?.addresses[i] ?? '';
        _city = _v?.city ?? '';
        _state = _v?.state ?? '';
        va = '${_v?.address?.capitalize() ?? ''},'
            '${_v?.city?.capitalize() ?? ''}';

        break;
      }
    }

    return va ?? '';
  }

  getProfileImage() =>
      _profileImage ??
      'https://www.rameng.ca/wp-content/uploads/2014/03/placeholder.jpg';

  void getUserImage() async {
    await APIManager.getUserImage().then((value) {
      if (value.status == 'success') {
        _profileImage = value?.data[0]?.photo ??
            'https://www.rameng.ca/wp-content/uploads/2014/03/placeholder.jpg';
        notifyListeners();
      }
    });
  }

  void deleteAddress(int id) async {
    await APIManager.deleteAddress({'address_id': id}, RIKeys.josKeys8)
        .then((value) {
      getAddress();
    });
  }

  void checkIdClicked(_val) async {
    // await Api
  }

  void getAllState() async {
    await APIManager.stateList(null, RIKeys.josKeys3).then((value) {
      if (value.status == 'success') {
        try {
          _stateList.addAll(value.data);
        } catch (e) {}
        notifyListeners();
      }
    });
  }

  Future<void> getImage(ImgSource source, GlobalKey<ScaffoldState> key) async {
    File image;
    image = await ImagePickerGC.pickImage(
        context: key.currentContext,
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
            iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0))
        .then((value) async {
      // image = croppedFile;
      image = value;
      await APIManager.profileImageUpdate(image, key.currentContext).then(
        (value) => getUserImage(),
      );
    });

    notifyListeners();
  }

  scanQR(BuildContext context) async {
    String qrResult;
    String result = "";
    try {
      await BarcodeScanner.scan().then((_val) async {
        qrResult = _val.rawContent;
        if (qrResult.length < 6) return;
        Provider.of<BusinessProfileProvider>(context, listen: false)
            ..setBusinessId(qrResult)
        ..refresh(1);
        Navigator.of(context).pushNamed('/businessProfile');
        print("qrResult:$qrResult");
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        result = "Camera permission was denied";
      } else
        result = "Unknown Error $ex";
    } on FormatException {
      result = "You pressed the back button before scanning anything";
    } catch (ex) {
      result = "Unknown Error $ex";
    }
  }

  allClear() {
    _profileImage = '';
    // acces.forEach((e) =>
    //   e = Acces()
    // );
    setAddresstype('Home');
  }

  onWillPop(context) {
    this.onWillPop(context);
  }
  // void getAllCity(String selectedCity, key) async {
  //   await APIManager.stateList(null, key).then((value) {
  //     if (value.status == 'success') {
  //       _stateList.addAll(value.data);
  //       notifyListeners();
  //     }
  //   });
  // }
}
