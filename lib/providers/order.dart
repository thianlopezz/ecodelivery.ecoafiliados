import 'package:ecodelivery/models/Order.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  dynamic _orden;
  Order _orderForDetails;

  get orden {
    return _orden;
  }

  get orderForDetails {
    return _orderForDetails;
  }

  setOrder(dynamic orden) {
    _orden = orden;
    notifyListeners();
  }

  setOrderForDetails(Order orderForDetails) {
    _orderForDetails = orderForDetails;
    notifyListeners();
  }
}
