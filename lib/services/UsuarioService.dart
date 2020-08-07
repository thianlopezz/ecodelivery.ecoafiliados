import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/ws.dart' as WS;

class UsuarioService {
  static dynamic updateUsuarioCuenta(usuarioCuenta) async {
    var uri = WS.urlApi + '/usuario';

    try {
      final response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(usuarioCuenta));

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

  static dynamic updateFcmToken(usuarioToken) async {
    var uri = WS.urlApi + '/comercio/fcmToken';

    try {
      final response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(usuarioToken));

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
