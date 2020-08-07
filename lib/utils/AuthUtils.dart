import 'dart:convert';

import 'package:ecodelivery/auth/login.dart';
import 'package:ecodelivery/utils/SessionUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'auth_utils.dart';
import '../constants/ws.dart' as WS;

class AuthUtils {
  static dynamic loginFb(FacebookLoginResult result) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
    dynamic profile = json.decode(graphResponse.body);

    profile['picture'] =
        'https://graph.facebook.com/${profile['id']}/picture?type=large';

    var uri = WS.urlApi + '/fb/login';

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(profile));

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

  static dynamic registerUser(usuario) async {
    var uri = WS.urlApi + '/registro';

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(usuario));

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

  static dynamic login(usuario) async {
    var uri = WS.urlApi + '/login/afiliado';

    try {
      final response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(usuario));

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

  static logoutUser(BuildContext context, SharedPreferences prefs, setUser) {
    prefs.setString(SessionUtils.authToken, null);
    prefs.setInt(SessionUtils.idUsuario, null);
    prefs.setString(SessionUtils.nombre, null);
    prefs.setString(SessionUtils.apellido, null);
    prefs.setString(SessionUtils.usuario, null);

    setUser(null);

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LoginPage()), (route) => true);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (r) => false);
  }

  // static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  //   scaffoldKey.currentState.showSnackBar(new SnackBar(
  //     content: new Text(message ?? 'You are offline'),
  //     behavior: SnackBarBehavior.floating,
  //   ));
  // }

  static fetch(var authToken, var endPoint) async {
    var uri = WS.urlApi + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': authToken},
      );

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
