import 'package:carousel_slider/carousel_slider.dart';
import 'package:favorito_user/component/ImageMaster.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Carousel/CarouselModel.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return FutureBuilder<CarouselModel>(
      future: APIManager.carousel({'business_id': widget.id}),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<CarouselModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: Text(loading));
        else if (snapshot.hasError)
          return Center(child: Text('Error : ${snapshot.error}'));
        else if (carouselModel != snapshot.data) {
          carouselModel = snapshot.data;
          return Container(
            padding: EdgeInsets.symmetric(vertical: sm.h(2)),
            height: sm.h(30),
            child: CarouselSlider(
                options: CarouselOptions(
                    autoPlay: false, aspectRatio: 2.0, enlargeCenterPage: true),
                items: carouselModel.data
                    .map(
                      (item) => InkWell(
                        onTap: () {
                          Provider.of<BusinessProfileProvider>(context,
                              listen: false)
                            ..setBusinessId(item.businessId)
                            ..refresh(1);
                          Navigator.of(context).pushNamed('/businessProfile');
                        },
                        child: Container(
                          width: sm.h(90),
                          height: sm.h(10),
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ImageMaster(url: item.photo)
                              // Image.network(

                              //   fit: BoxFit.cover,
                              // ),
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
