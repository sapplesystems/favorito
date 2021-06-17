import 'dart:async';
import 'package:Favorito/ui/setting/BusinessProfile/BusinessProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';

class MyGoogleMap extends StatefulWidget {
  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Align(
          alignment: Alignment.bottomRight,
          heightFactor: 0.3,
          widthFactor: 2.5,
          child: Consumer<BusinessProfileProvider>(
            builder: (context, data, child) {
              return GoogleMap(
                  initialCameraPosition:
                      data.getPosition() ?? data.getPosition(),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    print(
                        "datais:${data.getPosition().target.latitude}:${data.getPosition().target.longitude}");
                    _mapController.moveCamera(
                        CameraUpdate.newLatLng(data.getPosition().target));
                  },
                  mapType: MapType.normal,
                  markers: data.getMarget() ?? data.getMarget(),
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,

                  // minMaxZoomPreference: MinMaxZoomPreference(16, 18),
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  compassEnabled: false,
                  scrollGesturesEnabled: false,
                  trafficEnabled: true,
                  tiltGesturesEnabled: false,
                  onTap: (_va) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlacePicker(
                                  initialPosition: data.getPosition().target,
                                  apiKey:
                                      'AIzaSyBhxep9O8VQz-JHmJW2XSzgjTRemLv91sI', // Put YOUR OWN KEY here.
                                  onPlacePicked: (result) {
                                    try {
                                      data.setPosition([
                                        result.geometry.location.lat.toString(),
                                        result.geometry.location.lng.toString()
                                      ]);
                                      _mapController.moveCamera(
                                          CameraUpdate.newLatLng(
                                              data.getPosition().target));
                                      data.needSave(true);
                                    } catch (e) {
                                      print("movingError:${e.toString()}");
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  useCurrentLocation: false,
                                  usePinPointingSearch: true,
                                  enableMyLocationButton: true,
                                  enableMapTypeButton: true,
                                  searchForInitialValue: true,
                                ))).whenComplete(() {
                      setState(() {
                        print('moving1...');
                      });
                    });
                  });
            },
          ),
        ),
      ),
    );
  }
}
