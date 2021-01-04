import 'package:favorito_user/component/MapView.dart';
import 'package:favorito_user/component/myCarousel.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/businessOverViewModel.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/search/mostPopular.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OverviewTab extends StatefulWidget {
  BusinessProfileData data;
  OverviewTab({this.data});

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<OverviewTab> {
  List<String> imgList = [
    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F747245763149464166%2F&psig=AOvVaw01ayL99DVuQCObmuC7Iptn&ust=1608613543107000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKiN2s6m3u0CFQAAAAAdAAAAABAP,https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.outlookindia.com%2Foutlooktraveller%2Fexplore%2Fstory%2F69698%2Fmust-eat-foods-of-29-states-of-india&psig=AOvVaw01ayL99DVuQCObmuC7Iptn&ust=1608613543107000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKiN2s6m3u0CFQAAAAAdAAAAABAU'
  ];
  List<String> _attribute = [];
  SizeManager sm;
  CameraPosition _initPosition;
  String shortDisc =
      'Mr.Cafe, first Midnight Cafe in surat offering wide varieties of food and beverages, If you are planning for Private Party Mr Cafe is the best place.';

  String longDisc =
      'It\'s a nice VEG only restaurant. Good food, lovely staff and decent prices for the quality and quantity. A must visit when you are at Surat.';
  var fut;
  businessOverViewModel overviewData = businessOverViewModel();
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    fut = APIManager.baseUserProfileOverview(
        {"business_id": widget.data.businessId});
    for (int i = 0; i < widget.data.attributes.length; i++) {
      _attribute.add(widget.data.attributes[i].attributeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);

    return FutureBuilder<businessOverViewModel>(
        future: fut,
        builder: (BuildContext context,
            AsyncSnapshot<businessOverViewModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text(loading));
          else {
            if (overviewData != snapshot.data) overviewData = snapshot.data;
            List<String> listKey = ['Phone', 'Emial', 'Website', 'Address'];
            List<String> listValue = [
              widget.data?.phone,
              widget.data?.businessEmail,
              overviewData?.data[0]?.website.replaceAll('|_|', ' , '),
              overviewData?.data[0]?.address1 +
                  " " +
                  overviewData?.data[0]?.address2 +
                  " " +
                  overviewData?.data[0]?.address3
            ];
            List loc = overviewData?.data[0].location.split(',');
            _initPosition = CameraPosition(
                target: LatLng(double.parse(loc[0]), double.parse(loc[1])),
                zoom: 12);
            setDestination(loc);
            return Padding(
              padding: EdgeInsets.only(
                  top: sm.h(6), bottom: sm.h(2), left: sm.w(3), right: sm.w(3)),
              child: ListView(children: [
                Text(shortDisc,
                    style:
                        TextStyle(fontSize: 15, fontFamily: 'Gilroy-Regular')),
                myCarousel(),
                Text(
                  longDisc,
                  style: TextStyle(fontSize: 15, fontFamily: 'Gilroy-Regular'),
                ),
                for (int i = 0; i < listKey.length; i++)
                  Padding(
                    padding: EdgeInsets.only(top: sm.h(3)),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            listKey[i],
                            style: TextStyle(
                                fontFamily: 'Gilroy-Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Text(
                            listValue[i],
                            style: TextStyle(
                                color:
                                    (i == 0 || i == 2) ? myRed : Colors.black,
                                fontFamily: 'Gilroy-Regular',
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  height: sm.h(40),
                  child: loc != null
                      ? MyGoogleMap(
                          initPosition: _initPosition, marker: markers)
                      : Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var _va in _attribute)
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: sm.w(2), vertical: sm.h(.5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[600], //   width: 1,
                          ),
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _va,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(3)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Payment',
                          style: TextStyle(
                              fontFamily: 'Gilroy-Regular',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          overviewData?.data[0]?.paymentMethod
                              .replaceAll(',', ' , '),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Gilroy-Regular',
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: sm.h(2)),
                  child: Row(
                    children: [
                      Text(
                        'Most Popular',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy-Medium',
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: MostPopular(),
                )
              ]),
            );
          }
        });
  }

  void setDestination(List loc) {
    //  Marker destinationMarker = Marker(
    //     markerId: MarkerId('$destinationCoordinates'),
    //     position: LatLng(
    //       destinationCoordinates.latitude,
    //       destinationCoordinates.longitude,
    //     ),
    //     infoWindow: InfoWindow(
    //       title: 'Destination',
    //       snippet: _destinationAddress,
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //   );
  }
}
