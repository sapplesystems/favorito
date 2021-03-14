import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class usernameAddress extends StatefulWidget {
  const usernameAddress({
    Key key,
    @required this.addressData,
    @required String selectedAddress,
  })  : _selectedAddress = selectedAddress,
        super(key: key);

  final AddressListModel addressData;
  final String _selectedAddress;

  @override
  _usernameAddressState createState() => _usernameAddressState();
}

class _usernameAddressState extends State<usernameAddress> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Text(widget.addressData?.data?.userName ?? 'user',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text(widget._selectedAddress)
        ])));
  }
}
