import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/components/Input.dart';
import 'package:ecodelivery/models/Invoice.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/InvoiceService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;
import 'package:ecodelivery/providers/invoice.dart';

class InvoiceFormPage extends StatefulWidget {
  InvoiceFormPage(BuildContext context) {}

  @override
  _InvoiceFormPageState createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends State<InvoiceFormPage> {
  int _idDatosFacturacion;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController nombreController = TextEditingController();
  TextEditingController identificacionController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoContoller = TextEditingController();

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
    Invoice invoiceFromProvider =
        Provider.of<InvoiceProvider>(_scaffoldKey.currentContext, listen: false)
            .invoice;

    if (invoiceFromProvider != null) {
      setState(() {
        _idDatosFacturacion = invoiceFromProvider.idDatosFacturacion;
        nombreController =
            TextEditingController(text: invoiceFromProvider.nombre);
        identificacionController =
            TextEditingController(text: invoiceFromProvider.identificacion);
        correoController =
            TextEditingController(text: invoiceFromProvider.correo);
        telefonoContoller =
            TextEditingController(text: invoiceFromProvider.telefono);
        direccionController =
            TextEditingController(text: invoiceFromProvider.direccion);
      });
    }
  }

  _save(invoiceInfo) async {
    if (_formKey.currentState.validate()) {
      // _showLoading();

      await pr.show();

      var responseJson;

      if (invoiceInfo['idDatosFacturacion'] == null) {
        responseJson = await InvoiceService.saveNewInvoceData(invoiceInfo);
      } else {
        responseJson = await InvoiceService.updateInvoiceData(invoiceInfo);
      }

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
        // pr.update(message: responseJson['mensaje']);

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 27.0,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 128.0, 16.0, 16.0),
                  child: Center(
                    child: Text(
                      'Datos de facturación',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding:
                          EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Input(
                                label: 'Nombre o Razón Social',
                                controller: nombreController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa el nombre p la razón social';
                                  }
                                  return null;
                                }),
                            Input(
                                label: 'Cédula/RUC',
                                controller: identificacionController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa la identificación';
                                  }
                                  return null;
                                }),
                            SizedBox(height: 20.0),
                            Input(
                                label: 'Correo',
                                controller: correoController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa el correo';
                                  }
                                  return null;
                                }),
                            Input(
                                label: 'Teléfono',
                                controller: telefonoContoller,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa el teléfono';
                                  }
                                  return null;
                                }),
                            SizedBox(height: 20.0),
                            Input(
                                label: 'Dirección',
                                controller: direccionController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Ingresa el teléfono';
                                  }
                                  return null;
                                }),
                            SizedBox(height: 15.0),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  var invoiceInfo = {
                                    "idDatosFacturacion": _idDatosFacturacion,
                                    "idUsuario": usuario.idUsuario,
                                    "nombre": nombreController.text,
                                    "identificacion":
                                        identificacionController.text,
                                    "correo": correoController.text,
                                    "telefono": telefonoContoller.text,
                                    "direccion": direccionController.text,
                                  };

                                  _save(invoiceInfo);
                                },
                                color: THEME.greenThemeColor,
                                child: Text('Guardar',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            )
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
