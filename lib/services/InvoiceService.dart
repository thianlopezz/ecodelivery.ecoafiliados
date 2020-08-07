import 'dart:convert';

import 'package:ecodelivery/models/Invoice.dart';
import 'package:http/http.dart' as http;

import '../constants/ws.dart' as WS;

class InvoiceService {
  static Future<List<Invoice>> getDatosFacturacion(int idUsuario) async {
    var uri = WS.urlApi + '/invoice/${idUsuario}';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<Invoice> lista;
      // (data as List).map((i) => new Comercio.fromJson(i));
      lista = (json.decode(response.body) as List)
          .map((i) => Invoice.fromJson(i))
          .toList();
      return lista;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar tus datos de facturación.');
    }
  }

  static dynamic saveNewInvoceData(datosFacturacion) async {
    var uri = WS.urlApi + '/invoice';

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(datosFacturacion));

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

  static dynamic updateInvoiceData(datosFacturacion) async {
    var uri = WS.urlApi + '/invoice';

    try {
      final response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(datosFacturacion));

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
