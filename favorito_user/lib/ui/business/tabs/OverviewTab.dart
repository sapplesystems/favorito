import 'package:favorito_user/component/MapView.dart';
import 'package:favorito_user/component/myCarousel.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/Business/AttributesModel.dart';
import 'package:favorito_user/model/appModel/businessOverViewModel.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:favorito_user/services/APIManager.dart';
import 'package:favorito_user/ui/business/BusinessProfileProvider.dart';
import 'package:favorito_user/ui/search/mostPopular.dart';
import 'package:favorito_user/utils/MyColors.dart';
import 'package:favorito_user/utils/MyString.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
        {"business_id": widget?.data?.businessId});
    Attributes a = Attributes();
    a.attributeName = 'Online Menu';
    // widget.data.attributes.add(a);
    for (int i = 0; i < widget?.data?.attributes?.length ?? 0; i++) {
      _attribute.add(widget?.data?.attributes[i]?.attributeName ?? '');
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
            return Center(
                child: Text(
              loading,
              style: Theme.of(context).textTheme.headline6,
            ));
          else {
            if (overviewData != snapshot.data) overviewData = snapshot.data;
            List<String> listKey = ['Phone', 'Email', 'Website', 'Address'];
            List<String> listValue = [
              widget?.data?.phone ?? '',
              widget?.data?.businessEmail ?? '',
              overviewData?.data[0]?.website?.replaceAll('|_|', ' , '),
              "${overviewData?.data[0]?.address1 ?? ''} ${overviewData?.data[0]?.address2 ?? ''} ${overviewData?.data[0]?.address3 ?? ''}"
            ];
            List loc = overviewData?.data[0].location.split(',');
            markers.add(Marker(
                markerId: MarkerId('new Address'),
                position: LatLng(double.parse(loc[0]), double.parse(loc[1]))));
            // setDestination(loc);
            return Padding(
              padding: EdgeInsets.only(top: sm.h(4), bottom: sm.h(2)),
              child: Scrollbar(
                isAlwaysShown: true,
                showTrackOnHover: true,
                child: ListView(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.h(2)),
                    child: Text(shortDisc,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        textAlign: TextAlign.justify),
                  ),
                  SizedBox(
                    height: sm.h(25),
                    child: Consumer<BusinessProfileProvider>(
                        builder: (context, data, child) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.gethighlightsdata.length,
                          itemBuilder: (context, index) => Container(
                                width: sm.w(90),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: sm.w(4)),
                                  child: Card(
                                      elevation: 8,
                                      shadowColor:
                                          Colors.transparent.withOpacity(0.2),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                          data.gethighlightsdata[index].photo)),
                                ),
                              ));
                    }),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                  //   child: Container(
                  //     height: sm.h(25),
                  //     child:
                  //   ),
                  // ),

                  //myCarousel(overviewData?.data[0]?.businessId),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sm.h(2)),
                    child: Text(longDisc,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        textAlign: TextAlign.justify),
                  ),
                  for (int i = 0; i < listKey.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                          top: sm.h(3), left: sm.h(2), right: sm.h(2)),
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            listKey[i] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    fontFamily: 'Gilroy-Regular',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Text(
                            listValue[i] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: (i == 0 || i == 2) ? myRed : null,
                                    fontFamily: 'Gilroy-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                          ),
                        ),
                      ]),
                    ),
                  Container(
                    padding: EdgeInsets.all(sm.h(2)),
                    height: sm.h(40),
                    child: loc != null
                        ? MyGoogleMap(
                            initPosition: CameraPosition(
                                target: LatLng(
                                    double.parse(loc[0]), double.parse(loc[1])),
                                zoom: 12),
                            marker: markers)
                        : Container(),
                  ),
                  Container(
                    height: 40,
                    child:
                        ListView(scrollDirection: Axis.horizontal, children: [
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
                            // color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _va,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(sm.h(2)),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Payment',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          overviewData?.data[0]?.paymentMethod
                              ?.replaceAll(',', ' , '),
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: sm.h(2)),
                    child: Row(children: [
                      Text(
                        '\t\t\tSponsored',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ]),
                  ),
                  Container(
                    height: 215,
                    child: MostPopular(),
                  )
                ]),
              ),
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
