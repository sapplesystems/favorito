import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/search/SearchResult.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
          defaultTextColor: myRed,
          accentColor: Colors.grey,
          variantColor: Colors.black38,
          depth: 8,
          intensity: 0.65),
      usedTheme: UsedTheme.LIGHT,
      child: Material(
        child: NeumorphicBackground(
          child: _Home(),
        ),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  String _selectedAddress = "selected Address";
  List<String> _addressList = [];
  final List<String> imgList = [];
  var _mySearchEditTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCarousel();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    SizeManager sm = SizeManager(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: myBackGround),
        padding: EdgeInsets.only(top: 10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: sm.scaledWidth(4), right: sm.scaledWidth(2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://source.unsplash.com/random/400*400",
                      height: sm.scaledHeight(10),
                      fit: BoxFit.cover,
                      width: sm.scaledHeight(10),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jessica Saint",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        DropdownButton<String>(
                          value: _selectedAddress,
                          underline: Container(), // this is the magic
                          items: _addressList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAddress = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
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
                        print("clicked()");
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
                  for (var i = 0; i < 8; i++)
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Neumorphic(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.convex,
                                depth: 8,
                                lightSource: LightSource.topLeft,
                                color: myButtonBackground),
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.all(Radius.circular(12.0))),
                            child: Image.network(
                              "https://source.unsplash.com/random/40*40",
                              height: sm.scaledHeight(6),
                              fit: BoxFit.cover,
                              width: sm.scaledHeight(6),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text("Food"),
                          ),
                        ]),
                ],
              ),
            ),
            header(sm, "Hot & New Business"),
            Container(
              height: sm.scaledHeight(26),
              child: Padding(
                padding: EdgeInsets.only(bottom: sm.scaledHeight(2)),
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
            ),
          ],
        ),
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
            onTap: () {},
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
    await APIManager.carousel().then((value) {
      if (value.status == 'success') {
        if (value.data.length > 0) imgList.clear();
        for (var _va in value.data) imgList.add(_va.photo);
        setState(() {});
        print("imgList:${imgList.toString()}");
      }
    });
  }

  void getAddress() async {
    await APIManager.carousel().then((value) {
      if (value.status == 'success') {
        if (value.data.length > 0) imgList.clear();
        for (var _va in value.data) imgList.add(_va.photo);
        setState(() {});
        print("imgList:${imgList.toString()}");
      }
    });
  }
}
