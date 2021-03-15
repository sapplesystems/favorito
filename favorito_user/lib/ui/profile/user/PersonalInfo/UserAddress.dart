import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddressProvider.dart';
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
                  // Icon(Icons.),
                  Text('My Addresses',
                      style:
                          TextStyle(fontSize: 22, fontFamily: 'Gilroy-Bold')),
                  Row(children: [
                    InkWell(
                        onTap: () => vaTrue.getAddress(),
                        child: Icon(Icons.add_rounded, color: Colors.black)),
                    SizedBox(width: 10),
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
