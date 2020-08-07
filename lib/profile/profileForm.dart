import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/components/Input.dart';
import 'package:ecodelivery/components/Select.dart';
import 'package:ecodelivery/constants/validators.dart';
import 'package:ecodelivery/models/Invoice.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/InvoiceService.dart';
import 'package:ecodelivery/services/UsuarioService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;
import 'package:ecodelivery/providers/invoice.dart';
import 'package:ecodelivery/components/InputDate.dart';

class ProfileFormPage extends StatefulWidget {
  ProfileFormPage(BuildContext context) {}

  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  static DateTime now = DateTime.now();
  PhoneNumber number = PhoneNumber(isoCode: 'EC');

  String generoValue = '';
  DateTime feNacimiento = DateTime(
    now.year - 18,
    DateTime.now().month,
    DateTime.now().day,
  );

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController correoController = TextEditingController();
  TextEditingController contactoController = TextEditingController();

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController feNacimientoController = TextEditingController();
  TextEditingController telefonoContoller = TextEditingController();
  // GENERO

  TextEditingController bioController = TextEditingController();

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStuff();
    });
    // _getLocation();
  }

  void _initStuff() {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    if (usuario != null) {
      setState(() {
        // _idDatosFacturacion = invoiceFromProvider.idDatosFacturacion;
        number = PhoneNumber(
          isoCode: usuario.isoCode != null ? usuario.isoCode : 'EC',
          dialCode: usuario.dialCode != null ? usuario.dialCode : '593',
        );

        correoController = TextEditingController(text: usuario.correo);
        contactoController = TextEditingController(text: usuario.contacto);

        nombreController = TextEditingController(text: usuario.nombre);
        apellidoController = TextEditingController(text: usuario.apellido);
        feNacimientoController = TextEditingController(
            text: usuario.feNacimiento != null
                ? DateFormat('dd/MM/yyyy').format(usuario.feNacimiento)
                : '-');
        bioController = TextEditingController(text: usuario.bio);
        generoValue = usuario.genero;
        feNacimiento =
            usuario.feNacimiento != null ? usuario.feNacimiento : feNacimiento;
      });
    }
  }

  _update(usuarioCuenta) async {
    if (_formKey.currentState.validate()) {
      // _showLoading();

      await pr.show();

      var responseJson =
          await UsuarioService.updateUsuarioCuenta(usuarioCuenta);

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
        // pr.update(message: responseJson['mensaje']);
        Provider.of<SessionInfoProvider>(context, listen: false)
            .setUsuario(Usuario.fromJson(responseJson['usuario']));

        await pr.hide();

        Navigator.pop(context, responseJson['mensaje']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = createBlackProgressDialog(context);
    pr.style(message: 'Guardando.');

    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    return new Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 48.0,
              left: 16.0,
              // padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 27.0,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
                  child: Text(
                    'Información de la cuenta',
                    style:
                        TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Input(
                                label: 'Correo',
                                controller: correoController,
                                enabled: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa tu correo';
                                  } else if (!validateEmail(value)) {
                                    return 'Ingresa un correo válido';
                                  }
                                  return null;
                                }),
                            InternationalPhoneNumberInput(
                              initialValue: number,
                              textFieldController: contactoController,
                              onInputChanged: (PhoneNumber value) {
                                // setState(() {
                                //   this.number = value;
                                // });
                              },
                              // textStyle: TextStyle(color: Colors.white),
                              // selectorTextStyle: TextStyle(color: Colors.white),
                              formatInput: false,
                              errorMessage: "Ingresa un número válido",
                              inputDecoration: InputDecoration(
                                  labelText: 'Contacto',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: THEME.greenThemeColor),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: THEME.greenThemeColor)),
                                  enabledBorder: UnderlineInputBorder(
                                      // borderSide:
                                      //     BorderSide(color: Colors.white)
                                      )),
                            ),

                            SizedBox(height: 20.0),
                            Input(
                                label: 'Nombre',
                                controller: nombreController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa tu nombre';
                                  }
                                  return null;
                                }),
                            Input(
                                label: 'Apellido',
                                controller: apellidoController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa tu apellido';
                                  }
                                  return null;
                                }),
                            // InputDatePickerFormField(
                            //     firstDate: DateTime(1900, 1, 1),
                            //     lastDate: DateTime.now()),
                            InputDate(
                              label: 'Fecha de nacimiento',
                              selectedDate: feNacimiento,
                              inputTextValue:
                                  DateFormat('dd/MM/yyyy').format(feNacimiento),
                              controller: feNacimientoController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa tu fecha de nacimiento';
                                }
                                return null;
                              },
                              context: context,
                              onChange: (DateTime newValue) {
                                setState(() {
                                  // feNacimientoController =
                                  //     TextEditingController(
                                  //         text: DateFormat('dd/MM/yyyy')
                                  //             .format(newValue));

                                  feNacimiento = newValue;
                                });
                              },
                            ),

                            Select(
                              label: 'Género',
                              value: generoValue,
                              // helperText: datosfacturacionList.length == 1
                              //     ? 'Puedes registrar tus datos de facturación en la pantalla principal, Perfil > Datos de facturación'
                              //     : null,
                              options: ['', 'MASCULINO', 'FEMENINO', 'OTRO']
                                  .map<DropdownMenuItem<String>>((opcion) {
                                return DropdownMenuItem<String>(
                                  value: '${opcion}',
                                  child: Text('${opcion}'),
                                );
                              }).toList(),
                              onChange: (String newValue) {
                                if (newValue != '')
                                  setState(() {
                                    generoValue = newValue;
                                  });
                              },
                            ),
                            Input(
                              label: 'Bio',
                              maxLines: 4,
                              hintText: 'Me gusta comprar en Ecodelivery',
                              controller: bioController,
                            ),
                            SizedBox(height: 15.0),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () async {
                                  PhoneNumber number = await PhoneNumber
                                      .getRegionInfoFromPhoneNumber(
                                          contactoController.text,
                                          this.number.isoCode);

                                  String justNumber = contactoController.text;

                                  if (contactoController.text[0] == '0')
                                    justNumber =
                                        contactoController.text.substring(1);

                                  _update({
                                    'idUsuario': usuario.idUsuario,
                                    'nombre': nombreController.text.trim(),
                                    'apellido': apellidoController.text.trim(),
                                    'bio': bioController.text.trim(),
                                    'feNacimiento': DateFormat('yyyy-MM-dd')
                                        .format(feNacimiento),
                                    'genero': generoValue,
                                    'contacto': justNumber,
                                    'dialCode': number.dialCode,
                                    'isoCode': number.isoCode
                                  });
                                },
                                color: THEME.greenThemeColor,
                                child: Text('Guardar',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            SizedBox(height: 15.0),
                          ],
                        ),
                      )),
                ),
                // SizedBox(height: 15.0),
              ],
            ),
          ],
        ));
  }
}
