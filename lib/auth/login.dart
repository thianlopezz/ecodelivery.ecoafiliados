import 'dart:ui';

import 'package:ecodelivery/components/RoundedButton.dart';
import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/utils/AuthUtils.dart';
import 'package:ecodelivery/tabs.dart';
import 'package:ecodelivery/utils/SessionUtils.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/theme.dart' as THEME;

// TODO: corregir 'usuario y contrasena incorrecta'
// FIXME: pedido, logout y login no funciona error de dialgo

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  static const greenThemeColor = THEME.greenThemeColor;
  static const facebookThemeColor = THEME.facebookThemeColor;
  static const blackThemeColor = THEME.blackThemeColor;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  final usuarioController = TextEditingController();
  final contrasenaController = TextEditingController();

  // bool _isLoading = false;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = SessionUtils.getToken(_sharedPreferences);
    if (authToken != null) {
      Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed('/tabs');
    }
  }

  void initiateFacebookLogin() async {
    var login = FacebookLogin();
    var result = await login.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.error:
        print('Surgio un error.');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Debes aceptar los permisos.');
        break;
      case FacebookLoginStatus.loggedIn:
        getLoginFbAndRegistrate(result);
        break;
    }
  }

  getLoginFbAndRegistrate(FacebookLoginResult result) async {
    var responseJson = await AuthUtils.loginFb(result);

    if (responseJson == null) {
      await pr.hide();
      UiUtils.showSnackBar(
          _scaffoldKey, 'Algo Salió mal, vuelve a intentarlo luego.');
    } else if (responseJson == 'NetworkError') {
      await pr.hide();
      UiUtils.showSnackBar(_scaffoldKey, null);
    } else if (!responseJson['success']) {
      await pr.hide();
      UiUtils.showSnackBar(_scaffoldKey, responseJson['mensaje']);
    } else {
      SessionUtils.setSession(_sharedPreferences, responseJson);

      Provider.of<SessionInfoProvider>(context, listen: false)
          .setUsuario(Usuario.fromJson(responseJson['usuario']));

      /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         * **/
      Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed('/tabs');
    }
    // _hideLoading();
  }

  _login(usuario) async {
    if (_formKey.currentState.validate()) {
      // _showLoading();
      await pr.show();

      var responseJson = await AuthUtils.login(usuario);

      print(responseJson);

      if (responseJson == null) {
        await pr.hide();
        UiUtils.showSnackBar(
            _scaffoldKey, 'Algo Salió mal, vuelve a intentarlo luego.');
      } else if (responseJson == 'NetworkError') {
        await pr.hide();
        UiUtils.showSnackBar(_scaffoldKey, null);
      } else if (!responseJson['success']) {
        await pr.hide();
        UiUtils.showSnackBar(_scaffoldKey, responseJson['mensaje']);
      } else {
        SessionUtils.setSession(_sharedPreferences, responseJson);

        Provider.of<SessionInfoProvider>(context, listen: false)
            .setUsuario(Usuario.fromJson(responseJson['usuario']));

        /**
         * Removes stack and start with the new page.
         * In this case on press back on HomePage app will exit.
         * **/
        // Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed('/tabs');
        Navigator.pushAndRemoveUntil(_scaffoldKey.currentContext,
            MaterialPageRoute(builder: (context) => MyTabs()), (r) => false);
      }
      // _hideLoading();
    }

    // else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    pr = createBlackProgressDialog(context);
    pr.style(message: 'Iniciando sesión.');

    return new Scaffold(
        // resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: blackThemeColor,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.png"), fit: BoxFit.fitWidth)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 110.0, 0.0, 0.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            // "assets/giflogo.gif",
                            "assets/logo.png",
                            width: 150,
                          ),
                          Text(
                            'Afiliados',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: usuarioController,
                              style: new TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa tu usuario o correo';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: contrasenaController,
                              style: new TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              obscureText: true,
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment(1.0, 0.0),
                              padding: EdgeInsets.only(top: 15.0, left: 20.0),
                              child: InkWell(
                                child: Text(
                                  '¿Olvidaste tu contrseña?',
                                  style: TextStyle(
                                      color: greenThemeColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ComicNeue',
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            RoundedButton(
                                text: 'INICIAR SESIÓN',
                                onPress: () {
                                  _login({
                                    'usuario': usuarioController.text,
                                    'contrasena': contrasenaController.text,
                                  });
                                }),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      )),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ));
  }
}
