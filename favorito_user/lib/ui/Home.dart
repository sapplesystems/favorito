import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/serviceModel/AddressListModel.dart';
import 'package:favorito_user/model/serviceModel/ProfileImageModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();

  List<String> image = ['pizza', 'table', 'callender', 'ala', 'bag', 'home'];
  List<String> imagName = [
    'Food',
    'Book A Table',
    'Book An\nAppoinent',
    'Doctor',
    'Jobs',
    'Freelancers'
  ];
}

class _HomeState extends State<Home> {
  String _selectedAddress = "selected Address";
  final List<String> imgList = [];
  var _mySearchEditTextController = TextEditingController();
  AddressListModel addressData;
  ProfileImageModel profileImage;
  SizeManager sm;
  @override
  void initState() {
    super.initState();
    getUserImage();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      backgroundColor: myBackGround,
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(sm.scaledWidth(4)),
                child: myClipRect(profileImage: profileImage, sm: sm),
              ),
              usernameAddress(
                  addressData: addressData, selectedAddress: _selectedAddress),
              Padding(
                padding: EdgeInsets.only(
                    right: sm.scaledWidth(2), bottom: sm.scaledWidth(4)),
                child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icon/image_scanner.svg',
                      height: sm.scaledHeight(3),
                      fit: BoxFit.fill,
                    ),
                    onPressed: () {
                      getAddress();
                      getCarousel();
                    }),
              )
            ],
          ),
          Container(
            height: sm.scaledHeight(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imgList
                        .map((item) => Container(
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item,
                                    height: sm.scaledHeight(10),
                                    fit: BoxFit.cover,
                                    width: sm.scaledHeight(90),
                                  ),
                                ),
                              ),
                            ))
                        .toList()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: sm.scaledWidth(5), right: sm.scaledWidth(5)),
            child: EditTextComponent(
              ctrl: _mySearchEditTextController,
              title: "Search",
              security: false,
              valid: true,
              prefixIcon: 'search',
              prefClick: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchResult(_mySearchEditTextController.text)));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(sm.scaledWidth(4)),
            child: Wrap(
              runSpacing: sm.scaledHeight(5),
              spacing: sm.scaledHeight(5),
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < 6; i++)
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            depth: 8,
                            lightSource: LightSource.topLeft,
                            color: myButtonBackground,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(12.0)))),
                        child: Padding(
                          padding: EdgeInsets.all(sm.scaledHeight(2.5)),
                          child: SvgPicture.asset(
                            'assets/icon/${widget.image[i]}.svg',
                            height: sm.scaledHeight(5.5),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: sm.scaledHeight(2.5)),
                      child: Text(widget.imagName[i].toString(),
                          textAlign: TextAlign.center),
                    ),
                  ]),
              ],
            ),
          ),
          header(sm, "Hot & New Business"),
          Container(
            padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
            height: sm.scaledHeight(26),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 5; i++)
                  InkWell(
                    onTap: () {},
                    child: hotAndNewBusinessChild(sm),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget header(SizeManager sm, String title) {
    return Padding(
      padding: EdgeInsets.all(sm.scaledWidth(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            child: Text(
              "View all",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget hotAndNewBusinessChild(SizeManager sm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "https://source.unsplash.com/random/600*400",
                    height: sm.scaledHeight(11),
                    fit: BoxFit.cover,
                    width: sm.scaledWidth(38),
                  ),
                ),
                Positioned(
                  top: sm.scaledHeight(1),
                  left: sm.scaledWidth(1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    width: sm.scaledWidth(18),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star),
                          Text(
                            "4.6",
                            style: TextStyle(color: Colors.green),
                          )
                        ]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
              child: Text("Mr. Cafe",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            Padding(
              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
              child: Text("Restaurant | Cafe",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            ),
            Padding(
              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
              child: Text("1.2 km | Varachha",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
            ),
            Padding(
              padding: EdgeInsets.only(left: sm.scaledWidth(2)),
              child: Text("Open Now",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }

  void getCarousel() async {
    await APIManager.carousel(context).then((value) {
      if (value.status == 'success') {
        if (value.data.length > 0) imgList.clear();
        for (var _va in value.data) imgList.add(_va.photo);
        setState(() {});
      }
    });
  }

  void getAddress() async {
    await APIManager.getAddress(context).then((value) {
      if (value.status == 'success') {
        addressData = value;
        for (Addresses temp in addressData.data.addresses) {
          if (temp.defaultAddress == 1) {
            _selectedAddress = temp.address;
            break;
          }
        }
        setState(() {});
      }
    });
  }

  void getUserImage() async {
    await APIManager.getUserImage(context).then((value) {
      if (value.status == 'success') {
        setState(() {
          profileImage = value;
        });
        getCarousel();
      }
    });
  }
}

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
            Text(
              widget.addressData?.data?.userName ?? 'user',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(widget._selectedAddress),
          ],
        ),
      ),
    );
  }
}

class myClipRect extends StatefulWidget {
  const myClipRect({
    Key key,
    @required this.profileImage,
    @required this.sm,
  }) : super(key: key);

  final ProfileImageModel profileImage;
  final SizeManager sm;

  @override
  _myClipRectState createState() => _myClipRectState();
}

class _myClipRectState extends State<myClipRect> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        widget.profileImage == null
            ? "https://source.unsplash.com/random/40*40"
            : widget.profileImage.data.length == 0
                ? "https://source.unsplash.com/random/40*40"
                : widget.profileImage.data[0].photo,
        height: widget.sm.scaledHeight(8),
        fit: BoxFit.cover,
        width: widget.sm.scaledHeight(8),
      ),
    );
  }
}
