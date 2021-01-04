import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Carousel/CarouselModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class myCarousel extends StatefulWidget {
  String id;
  myCarousel([this.id]);
  @override
  _myCarouselState createState() => _myCarouselState();
}

class _myCarouselState extends State<myCarousel> {
  CarouselModel carouselModel = CarouselModel();
  var fut;
  SizeManager sm;

  @override
  void initState() {
    super.initState();
    fut = APIManager.carousel(context, {});
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<CarouselModel>(
      future: APIManager.carousel(context, {'business_id': widget.id}),
      builder: (BuildContext context, AsyncSnapshot<CarouselModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: Text(loading));
        else if (snapshot.hasError)
          return Center(child: Text('Error : ${snapshot.error}'));
        else if (carouselModel != snapshot.data) {
          carouselModel = snapshot.data;
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
                items: carouselModel.data
                    .map(
                      (item) => InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/businessProfile',
                              arguments: item.businessId);
                        },
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.photo,
                              height: sm.h(10),
                              fit: BoxFit.cover,
                              width: sm.h(90),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()),
          );
        }
      },
    );
  }
}
