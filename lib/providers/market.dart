import 'package:ecodelivery/models/Comercio.dart';
import 'package:flutter/material.dart';

class MarketProvider with ChangeNotifier {
  Comercio _comercio;

  get comercio {
    return _comercio;
  }

  setComercio(Comercio comercio) {
    _comercio = comercio;
    notifyListeners();
  }
}
