import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../../utils/Extentions.dart';

class UserAddressProvider extends ChangeNotifier {
  String _profileImage;
  AddressListModel addressListModel = AddressListModel();
  UserAddressProvider() {
    getAddress();
    getUserImage();
  }
  getAddress() async {
    // pr.show().timeout(Duration(seconds: 5));
    await APIManager.getAddress().then((value) {
      // pr.hide();
      if (value.status == 'success') {
        addressListModel = value;
        notifyListeners();
      }
    });
  }

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
        va =
            '${_v?.address?.capitalize() ?? ''},${_v?.city?.capitalize() ?? ''}';

        break;
      }
    }
    notifyListeners();
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
}
