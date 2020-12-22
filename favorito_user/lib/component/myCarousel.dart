import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class myCarousel extends StatefulWidget {
  List dataList;
  myCarousel({this.dataList});
  @override
  _myCarouselState createState() => _myCarouselState();
}

class _myCarouselState extends State<myCarousel> {
  SizeManager sm;
  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Container(
      padding: EdgeInsets.only(
          top: sm.h(6), bottom: sm.h(2), left: sm.w(3), right: sm.w(3)),
      height: sm.h(30),
      child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
          items: widget.dataList
              .map(
                (item) => Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item,
                      height: sm.h(10),
                      fit: BoxFit.cover,
                      width: sm.h(90),
                    ),
                  ),
                ),
              )
              .toList()),
    );
  }
}
