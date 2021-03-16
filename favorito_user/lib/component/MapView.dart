import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatefulWidget {
  CameraPosition initPosition;
  Completer<GoogleMapController> controller;
  Set<Marker> marker;
  MyGoogleMap({this.initPosition, this.controller, this.marker});
  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          heightFactor: 0.3,
          widthFactor: 2.5,
          child: GoogleMap(
            initialCameraPosition: widget.initPosition,
            onMapCreated: (GoogleMapController controller) =>
                widget.controller.complete(controller),
            mapType: MapType.normal,
            markers: widget.marker,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomControlsEnabled: true,
            tiltGesturesEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(16, 18),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
        ),
      ),
    );
  }
}
