import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class UserAddress extends StatelessWidget {
  UserAddressProvider vaTrue;
  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<UserAddressProvider>(context, listen: true);

    return Consumer<UserAddressProvider>(builder: (context, data, child) {
      return ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Address',
                    style: TextStyle(fontSize: 22, fontFamily: 'Gilroy-Bold'),
                  ),
                  Row(children: [
                    InkWell(
                        onTap: () => vaTrue.getAddress(),
                        child: Icon(Icons.refresh, color: Colors.black)),
                    SizedBox(width: 10),
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.black))
                  ])
                ]),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.addressListModel.data.addresses.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Addresses da = data.addressListModel.data.addresses[index];
                var _v = '${da.address},\n${da.city} ${da.state},${da.pincode}';
                return InkWell(
                  onTap: () {
                    vaTrue.seSelectedAddress(index);
                    Navigator.pop(context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ListTile(title: Text(_v)), Divider()],
                  ),
                );
              },
            ),
          )
        ],
      );
    });
  }
}

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

  seSelectedAddress(int index) {
    for (int _i = 0; _i < this.addressListModel.data.addresses.length; _i++) {
      this.addressListModel.data.addresses[index].defaultAddress = 0;
    }
    this.addressListModel.data.addresses[index].defaultAddress = 1;
    notifyListeners();
  }

  Addresses getSelectedAddress() {
    Addresses v;
    for (int i = 0; i < this.addressListModel.data.addresses.length; i++) {
      if (this.addressListModel.data.addresses[i].defaultAddress == 1) {
        v = this.addressListModel.data.addresses[i];
        break;
      }
    }
    notifyListeners();
    return v;
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
