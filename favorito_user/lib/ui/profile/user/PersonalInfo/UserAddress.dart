import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/AddressListModel.dart';
import 'package:favorito_user/ui/profile/user/PersonalInfo/UserAddressProvider.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/RIKeys.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class UserAddress extends StatelessWidget {
  SizeManager sm;
  UserAddressProvider vaTrue;
  UserAddressProvider vaFalse;

  @override
  Widget build(BuildContext context) {
    vaTrue = Provider.of<UserAddressProvider>(context, listen: true);
    vaFalse = Provider.of<UserAddressProvider>(context, listen: false);
    sm = SizeManager(context);
    return Scaffold(
      key: RIKeys.josKeys8,
      backgroundColor: myBackGround,
      body: Consumer<UserAddressProvider>(builder: (context, data, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: sm.h(2)),
          child: ListView(physics: NeverScrollableScrollPhysics(), children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.keyboard_backspace, size: 24)),
              InkWell(
                  onTap: () => vaTrue.getAddress(),
                  child: Icon(Icons.refresh, color: Colors.black))
            ]),
            SizedBox(height: sm.h(4)),
            Text('My Addresses',
                style: TextStyle(fontSize: 22, fontFamily: 'Gilroy-Regular')),
            InkWell(
                onTap: () {
                  data.setEditId(null);
                  Navigator.of(context)
                      .pushNamed('/addAddress')
                      .whenComplete(() => vaTrue.getAddress());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: sm.h(2)),
                  child: Row(children: [
                    Icon(Icons.add, size: 26, color: myRed),
                    Text(
                      '\tAdd Address',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Gilroy-Medium'),
                    ),
                  ]),
                )),
            Divider(),
            Container(
              height: sm.h(46),
              width: sm.w(90),
              child: Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        data.addressListModel?.data?.addresses?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Addresses da =
                          data.addressListModel.data.addresses[index];
                      var _v =
                          '${da.address},\n${da.city} ${da.state},${da.pincode}'
                              .trim();
                      return InkWell(
                        onTap: () {
                          vaTrue.seSelectedAddress(index);
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          da.addressType.toLowerCase() == 'home'
                                              ? Icons.home
                                              : da.addressType.toLowerCase() ==
                                                      'office'
                                                  ? Icons.work_outline
                                                  : da.addressType
                                                              .toLowerCase() ==
                                                          'hotel'
                                                      ? Icons.location_city
                                                      : Icons.person_pin_circle,
                                          color: da.defaultAddress == 1
                                              ? myRed
                                              : null,
                                        ),
                                        onPressed: () {}),
                                    Expanded(
                                        child: Text(_v,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Gilroy-Regular'))),
                                    PopupMenuButton(
                                      onSelected: (_val) {
                                        if (_val == 'Edit') {
                                          data.setEditId(da.id.toString());
                                          Navigator.of(context)
                                              .pushNamed('/addAddress')
                                              .whenComplete(
                                                  () => vaTrue.getAddress());
                                        } else if (_val == 'Delete') {
                                          vaTrue.deleteAddress(da.id);
                                        }
                                        print("$_v" + ':' + "$_val");
                                      },
                                      child: Row(children: [
                                        Icon(Icons.more_vert, size: 20),
                                      ]),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                            value: 'Edit', child: Text('Edit')),
                                        PopupMenuItem<String>(
                                            value: 'Delete',
                                            child: Text('Delete'))
                                      ],
                                    )
                                  ]),
                              Divider()
                            ]),
                      );
                    }),
              ),
            )
          ]),
        );
      }),
    );
  }
}

class myDropDown extends StatefulWidget {
  List dataList;
  int selectedIndex;

  myDropDown({this.dataList, this.selectedIndex});

  @override
  _myDropDownState createState() => _myDropDownState();
}

class _myDropDownState extends State<myDropDown> {
  SizeManager sm;

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Padding(
        padding: EdgeInsets.only(top: sm.h(2)),
        child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.convex,
                depth: 8,
                lightSource: LightSource.top,
                color: Colors.white,
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.all(Radius.circular(30.0)))),
            child: DropdownButton(
                // value: _selectedService,
                isExpanded: true,
                hint: Padding(
                  padding: EdgeInsets.only(left: sm.w(14), right: sm.w(6)),
                  child: Text("Select Service"),
                ),
                underline: Container(),
                // this is the magic
                items: widget.dataList?.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                      value: value,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: sm.w(2)),
                          child: Text(value)));
                })?.toList(),
                onChanged: (value) {
                  // setState(() {
                  // _selectedService = value;
                  // });
                })));
  }
}
