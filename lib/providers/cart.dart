import 'package:ecodelivery/models/Producto.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Producto> _productos = [];
  double _total = 0.0;
  double _totalConFeeEnvio = 0.0;
  int _cantidadItems = 0;

  get productos {
    return _productos;
  }

  get total {
    return _total;
  }

  get totalConFeeEnvio {
    return _totalConFeeEnvio;
  }

  get cantidadItems {
    return _cantidadItems;
  }

  setProductos(List<Producto> productos) {
    var sum = 0.0;
    productos.forEach((prodcutoItem) {
      sum += double.parse(prodcutoItem.price) * prodcutoItem.quantity;
    });

    _total = sum;
    _totalConFeeEnvio = total + 1.50;
    _cantidadItems = productos.length;
    _productos = productos;
    notifyListeners();
  }
}
