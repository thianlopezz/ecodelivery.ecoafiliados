import 'dart:convert';

import 'package:ecodelivery/models/Location.dart';
import 'package:http/http.dart' as http;
// import 'auth_utils.dart';
import '../constants/ws.dart' as WS;

class LocationService {
  static Future<List<Location>> getUbicaciones(int idUsuario) async {
    var uri = WS.urlApi + '/location/${idUsuario}';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<Location> lista;
      // (data as List).map((i) => new Comercio.fromJson(i));
      lista = (json.decode(response.body) as List)
          .map((i) => Location.fromJson(i))
          .toList();
      return lista;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar tus ubicaciones.');
    }
  }

  static dynamic saveNewLocation(ubicacion) async {
    var uri = WS.urlApi + '/location';

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(ubicacion));

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

  static dynamic updateLocation(ubicacion) async {
    var uri = WS.urlApi + '/location';

    try {
      final response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(ubicacion));

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
