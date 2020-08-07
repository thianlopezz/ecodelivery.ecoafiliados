import 'dart:convert';

import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/utils/SessionUtils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'auth_utils.dart';
import '../constants/ws.dart' as WS;

class ComercioService {
  static Future<Comercio> getComercio(String idComercio) async {
    var uri = WS.urlApi + '/comercio/$idComercio';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Comercio.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar los comercios');
    }
  }

  static Future<List<Comercio>> getComercios() async {
    var uri = WS.urlApi + '/comercios';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(json.decode(response.body));

      List<Comercio> lista;
      // (data as List).map((i) => new Comercio.fromJson(i));
      lista = (json.decode(response.body) as List)
          .map((i) => Comercio.fromJson(i))
          .toList();
      return lista;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar los comercios');
    }
  }

  static Future<dynamic> setOpenComercio(String idComercio, int isOpen) async {
    try {
      var uri = WS.urlApi + '/comercio/open';
      final response = await http
          .put(uri, body: {'idComercio': idComercio, 'isOpen': '$isOpen'});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('No se puedo combiar el estado de tu tienda');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> setHighRequested(
      String idComercio, int highRequested) async {
    try {
      var uri = WS.urlApi + '/comercio/highRequested';
      final response = await http.put(uri,
          body: {'idComercio': idComercio, 'highRequested': '$highRequested'});

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('No combiar el estado de tu tienda');
      }
    } catch (e) {
      print(e);
    }
  }
}
