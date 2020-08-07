import 'dart:convert';

import 'package:ecodelivery/models/Categoria.dart';
import 'package:ecodelivery/models/Order.dart';
import 'package:http/http.dart' as http;

import '../constants/ws.dart' as WS;

class CategoriaService {
  static Future<List<Categoria>> getCategoriasMacro() async {
    var uri = WS.urlApi + '/categorias';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<Categoria> lista;
      // (data as List).map((i) => new Comercio.fromJson(i));
      lista = (json.decode(response.body) as List)
          .map((i) => Categoria.fromEcoJson(i))
          .toList();
      return lista;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar las categorías.');
    }
  }

  static Future<List<Categoria>> getCategorias(int idComercio) async {
    var uri = WS.urlApi + '/categorias/woo/$idComercio';
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<Categoria> lista;
      // (data as List).map((i) => new Comercio.fromJson(i));
      lista = (json.decode(response.body) as List)
          .map((i) => Categoria.fromJson(i))
          .toList();
      return lista;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('No se pudieron cargar las categorías.');
    }
  }
}
