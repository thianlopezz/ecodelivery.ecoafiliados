import 'dart:convert';

import 'package:ecodelivery/models/Producto.dart';
import 'package:http/http.dart' as http;
// import 'auth_utils.dart';
import '../constants/ws.dart' as WS;

class ProductoService {
  static Future<List<Producto>> getProductos(int idComercio) async {
    var uri = WS.urlApi + '/productos/${idComercio}';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<Producto> lista;
      // (data as List).map((i) => new Comercio.fromJson(i));
      lista = (json.decode(response.body) as List)
          .map((i) => Producto.fromJson(i))
          .toList();
      return lista;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar los comercios');
    }
  }

  static Future<dynamic> setStockStatus(
      String idComercio, String idProducto, String stockStatus) async {
    try {
      var uri = WS.urlApi + '/producto/stock';
      final response = await http.put(uri, body: {
        'idComercio': idComercio,
        'idProducto': '$idProducto',
        'stockStatus': '$stockStatus'
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('No se puedo combiar el estado de tu tienda');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> setFeatured(
      String idComercio, String idProducto, bool featured) async {
    try {
      var uri = WS.urlApi + '/producto/featured';
      final response = await http.put(uri, body: {
        'idComercio': idComercio,
        'idProducto': '$idProducto',
        'featured': featured ? '1' : '0'
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('No se puedo combiar el estado de tu tienda');
      }
    } catch (e) {
      print(e);
    }
  }
}
