import 'package:ecodelivery/models/Location.dart';
import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  Location _location;
  Location _locationForDelivery;

  get location {
    return _location;
  }

  get locationForDelivery {
    return _locationForDelivery;
  }

  setLocation(Location location) {
    _location = location;
    notifyListeners();
  }

  setLocationForDelivery(Location locationForDelivery) {
    _locationForDelivery = locationForDelivery;
    notifyListeners();
  }
}
