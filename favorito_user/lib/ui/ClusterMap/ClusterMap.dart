// @dart=2.9
import 'package:favorito_user/component/EditTextComponent.dart';
import 'package:favorito_user/config/SizeManager.dart';
import 'package:favorito_user/model/appModel/search/BusinessProfileData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
class ClusterMap extends StatefulWidget {
  List<BusinessProfileData> list;
  ClusterMap({this.list});
  @override
  _ClusterMapState createState() => _ClusterMapState();
}

class _ClusterMapState extends State<ClusterMap> {
  final PopupController _popupController = PopupController();
SizeManager sm;
  List<Marker> markers;
  int pointIndex;
  List points = [
    LatLng(51.5, -0.09),
    LatLng(49.8566, 3.3522),
  ];

  @override
  void initState() {
    pointIndex = 0;
    int i;
    for( var v in widget.list){
    // markers = [
    //   Marker(
    //     anchorPos: AnchorPos.align(AnchorAlign.center),
    //     height: 30,
    //     width: 30,
    //     point: points[0],
    //     builder: (ctx) => Icon(Icons.pin_drop),
    //   )
    // ]  ; 
      print(v.location);
    // points.add(LatLng(v.location.split(',')[0],v.location.split(',')[1]));
    }
    markers = [
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: points[pointIndex],
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(28.5970, 77.2009),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(28.4472, 77.0406),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(53.3488, -6.2613),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(48.8566, 2.3522),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
      Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(49.8566, 3.3522),
        builder: (ctx) => Icon(Icons.pin_drop),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sm = SizeManager(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pointIndex++;
          if (pointIndex >= points.length) {
            pointIndex = 0;
          }
          setState(() {
            markers[0] = Marker(
              point: points[pointIndex],
              anchorPos: AnchorPos.align(AnchorAlign.center),
              height: 30,
              width: 30,
              builder: (ctx) => Icon(Icons.pin_drop),
            );
            markers = List.from(markers);
          });
        },
        child: Icon(Icons.refresh),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: points[0],
              zoom: 5,
              maxZoom: 15,
              plugins: [
                MarkerClusterPlugin(),
              ],
              onTap: (_) => _popupController
                  .hidePopup(), // Hide popup when the map is tapped.
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                size: Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: markers,
                polygonOptions: PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                popupOptions: PopupOptions(
                    popupSnap: PopupSnap.markerTop,
                    popupController: _popupController,
                    popupBuilder: (_, marker) => Container(
                          width: 200,
                          height: 100,
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () => debugPrint('Popup tap!'),
                            child: Text(
                              'Container popup for marker at ${marker.point}',style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.black),
                            ),
                          ),
                        )),
                builder: (context, markers) {
                  return FloatingActionButton(
                    onPressed: null,
                    child: Text(markers.length.toString()),
                  );
                },
              ),
            ],
          ),
        Container(
          margin: EdgeInsets.only(top:50),
            height: sm.h(10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: sm.w(5), right: sm.w(5), top: sm.h(1)),
                      child: EditTextComponent(
                          // controller: _mySearchEditTextController,
                          title: "Search",
                          suffixTxt: '',
                          hint: 'Search',
                          security: false,
                          valid: true,
                          maxLines: 1,
                          maxlen: 100,
                          keyBoardAction: TextInputAction.search,
                          // atSubmit: (_val) => executeSearch(SearchReqData(
                          //     text: _mySearchEditTextController.text)),
                          prefixIcon: 'search',
                          // prefClick: () => executeSearch(SearchReqData(
                          //     text: _mySearchEditTextController.text)
                          //     )
                              )
                              ),
                ),
                //Don't remove it is filter part for search

                // Padding(
                //   padding: EdgeInsets.only(right: sm.w(5), bottom: sm.h(2)),
                //   child: Card(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(8)),
                //       ),
                //       elevation: 10,
                //       child: Padding(
                //           padding: const EdgeInsets.all(12.0),
                //           child: InkWell(
                //             onTap: () => showPopup(
                //                 sm, context, _popupBody(sm), 'Select Filters'),
                //             child: SvgPicture.asset('assets/icon/filter.svg',
                //                 height: sm.h(2), fit: BoxFit.fitHeight),
                //           ))),
                // ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}