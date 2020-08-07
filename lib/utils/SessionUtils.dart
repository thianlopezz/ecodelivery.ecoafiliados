import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/sessionInfo.dart';

class SessionUtils {
  // Keys to store and fetch data from SharedPreferences
  static final String authToken = 'authToken';
  static final String idUsuario = 'idUsuario';
  static final String nombre = 'nombre';
  static final String apellido = 'apellido';
  static final String usuario = 'usuario';

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authToken);
  }

  static String getUsuario(SharedPreferences prefs) {
    return prefs.getString(usuario);
  }

  static setSession(SharedPreferences prefs, var response) {
    prefs.setString(authToken, response['authToken']);

    var usuarioData = response['usuario'];

    prefs.setInt(idUsuario, usuarioData['idUsuario']);
    prefs.setString(nombre, usuarioData['nombre']);
    prefs.setString(apellido, usuarioData['apellido']);
    prefs.setString(usuario, jsonEncode(usuarioData));
  }
}
