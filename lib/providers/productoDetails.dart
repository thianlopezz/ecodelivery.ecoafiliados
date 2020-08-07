import 'package:ecodelivery/models/Producto.dart';
import 'package:flutter/material.dart';

class ProductoDetalleProvider with ChangeNotifier {
  Producto _producto;

  get producto {
    return _producto;
  }

  setProductoDetalle(Producto producto) {
    _producto = producto;
    notifyListeners();
  }
}
