import 'package:ecodelivery/models/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionInfoProvider with ChangeNotifier {
  Usuario _usuario;

  get usuario {
    return _usuario;
  }

  setUsuario(Usuario usuario) {
    _usuario = usuario;

    notifyListeners();
  }
}
