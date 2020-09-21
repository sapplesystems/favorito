import 'dart:async';

import 'package:location/location.dart';

class LocationService {
  UserLocation _currentLocation;
  Location location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == "PermissionStatus.granted") {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
                lat: locationData.latitude, lon: locationData.longitude));
          }
        });
      } else {
        //   location.onLocationChanged.listen((locationData) {
        //     if (locationData != null) {
        //       _locationController.add(UserLocation(
        //           lat: locationData.latitude, lon: locationData.longitude));
        //     }
        //   });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var _userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          lat: _userLocation.latitude, lon: _userLocation.longitude);
    } catch (e) {
      //toast for not able to accewss location e
    }
    return _currentLocation;
  }
}

class UserLocation {
  final double lat;
  final double lon;
  UserLocation({this.lat, this.lon});
}
