import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/constants/validators.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/utils/AuthUtils.dart';
import 'package:ecodelivery/utils/SessionUtils.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/theme.dart' as THEME;

import 'package:ecodelivery/components/RoundedButton.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // bool _isLoading = false;
  ProgressDialog pr;

  PhoneNumber number = PhoneNumber(isoCode: 'EC');

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  // Controladores de TextInputs
  final correoController = TextEditingController();
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final repetirContrasenaController = TextEditingController();
  final contactoController = TextEditingController();

  static DateTime now = DateTime.now();
  static DateTime selectedDate = DateTime(
    now.year - 18,
    DateTime.now().month,
    DateTime.now().day,
  );

  var feNacimientoController = new TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(selectedDate));

  @override
  void initState() {
    super.initState();
    _fetchSession();
  }

  _fetchSession() async {
    _sharedPreferences = await _prefs;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        feNacimientoController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
  }

  _registerUser(usuario) async {
    await pr.show();

    var responseJson = await AuthUtils.registerUser(usuario);

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

      var usuario = responseJson['usuario'];

      pr.update(message: 'Usuario registrado correctamente.');

      new Future.delayed(const Duration(milliseconds: 2500), () {
        pr.update(message: 'Estamos alistando todo para ti.');

        new Future.delayed(const Duration(milliseconds: 2500), () {
          Provider.of<SessionInfoProvider>(context, listen: false)
              .setUsuario(Usuario.fromJson(usuario));
          Navigator.of(_scaffoldKey.currentContext).pushReplacementNamed('/');
          // .popAndPushNamed('/');
        });
      });
    }
  }

  String contrasenaValidator(value) {
    if (value.isEmpty) {
      return 'Ingresa una contraseña';
    } else if (contrasenaController.text != repetirContrasenaController.text) {
      return 'Las contraseñas no coinciden';
    } else if (contrasenaController.text.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    correoController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    contrasenaController.dispose();
    repetirContrasenaController.dispose();
    contactoController.dispose();
    contactoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = createBlackProgressDialog(context);
    pr.style(message: 'Estamos validando tus datos.');

    return new Scaffold(
        key: _scaffoldKey,
        // resizeToAvoidBottomPadding: false,
        backgroundColor: THEME.blackThemeColor,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.png"), fit: BoxFit.fitWidth)),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            size: 30,
                            color: THEME.greenThemeColor,
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Image.asset(
                          // "assets/giflogo.gif",
                          "assets/logo.png",
                          width: 150,
                        ),
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              controller: nombreController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa tu nombre';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            SizedBox(height: 5.0),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              controller: apellidoController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa tu apellido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Apellido',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: TextFormField(
                                    enabled: false,
                                    style: new TextStyle(color: Colors.white),
                                    controller: feNacimientoController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Ingresa tu fecha de nacimiento';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Fecha de nacimiento',
                                        labelStyle: TextStyle(
                                            fontFamily: 'ComicNeue',
                                            fontWeight: FontWeight.bold,
                                            color: THEME.greenThemeColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: THEME.greenThemeColor)),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white))),
                                    // obscureText: true,
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.calendar_today,
                                      color: THEME.greenThemeColor,
                                    ),
                                    onPressed: () => _selectDate(context),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              controller: correoController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa tu correo';
                                } else if (!validateEmail(value)) {
                                  return 'Ingresa un correo válido';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Correo',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            SizedBox(height: 5.0),
                            InternationalPhoneNumberInput(
                              initialValue: number,
                              textFieldController: contactoController,
                              onInputChanged: (PhoneNumber value) {
                                // setState(() {
                                //   this.number = value;
                                // });
                              },
                              textStyle: TextStyle(color: Colors.white),
                              selectorTextStyle: TextStyle(color: Colors.white),
                              formatInput: false,
                              errorMessage: "Ingresa un número válido",
                              inputDecoration: InputDecoration(
                                  labelText: 'Contacto',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              controller: contrasenaController,
                              validator: contrasenaValidator,
                              decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              obscureText: true,
                            ),
                            SizedBox(height: 5.0),
                            TextFormField(
                              style: new TextStyle(color: Colors.white),
                              controller: repetirContrasenaController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Repite la contraseña';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Repetir contraseña',
                                  labelStyle: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              obscureText: true,
                            ),
                            SizedBox(height: 40.0),
                            RoundedButton(
                                text: 'REGISTRARME',
                                onPress: () async {
                                  if (!_formKey.currentState.validate()) return;

                                  PhoneNumber number = await PhoneNumber
                                      .getRegionInfoFromPhoneNumber(
                                          contactoController.text,
                                          this.number.isoCode);

                                  String justNumber = contactoController.text;

                                  if (contactoController.text[0] == '0')
                                    justNumber =
                                        contactoController.text.substring(1);

                                  _registerUser({
                                    'nombre': nombreController.text.trim(),
                                    'apellido': apellidoController.text.trim(),
                                    'feNacimiento': selectedDate.toString(),
                                    'correo': correoController.text.trim(),
                                    'contacto': justNumber,
                                    'contrasena': contrasenaController.text,
                                    'contrasena1':
                                        repetirContrasenaController.text,
                                    'dialCode': number.dialCode,
                                    'isoCode': number.isoCode
                                  });
                                }),
                            SizedBox(height: 20.0),
                            Container(
                              height: 40.0,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1.0),
                                    color: THEME.facebookThemeColor,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: ImageIcon(
                                          AssetImage('assets/facebook.png')),
                                    ),
                                    SizedBox(width: 10.0),
                                    Center(
                                      child: Text('Continuar con facebook',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'ComicNeue')),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
