import 'dart:convert';

import 'package:ecodelivery/models/Order.dart';
import 'package:http/http.dart' as http;

import '../constants/ws.dart' as WS;

class OrderService {
  static Future<List<Order>> getOrders(int idComercio, String estado) async {
    try {
      var uri = WS.urlApi + '/order/$idComercio/$estado';
      final response = await http.get(uri);
      // .timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        List<Order> lista;
        // (data as List).map((i) => new Comercio.fromJson(i));
        lista = (json.decode(response.body) as List)
            .map((i) => Order.fromJson(i))
            .toList();
        return lista;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('No se pudieron cargar tus pedidos.');
      }
    } catch (e) {
      print(e);
      throw Exception('No se pudieron cargar tus pedidos.');
    }
  }

  static dynamic saveNewOrder(orden) async {
    var uri = WS.urlApi + '/order/${orden['idComercio']}';

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(orden));

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic updateState(Order orden, String notas) async {
    var uri = WS.urlApi + '/order/state';

    try {
      final response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'idOrden': orden.idOrden,
            'idUsuario': orden.idUsuario,
            'idWoo': orden.idWoo,
            'idComercio': orden.idComercio,
            'estado': orden.estado,
            'notas': notas
          }));

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
}
