import 'package:ecodelivery/models/Invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/theme.dart' as THEME;
import 'package:ecodelivery/utils/ConfirmAction.dart';
import 'package:url_launcher/url_launcher.dart';

class UiUtils {
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'You are offline'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static Future<dynamic> asyncInvoiceInfoDialog(
      BuildContext context, Invoice invoice) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Datos de facturación',
            style: TextStyle(color: THEME.greenThemeColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  "Nombre",
                  style: TextStyle(
                      // color: THEME.greenThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                child: Text(
                  invoice.nombre,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  "Identificación",
                  style: TextStyle(
                      // color: THEME.greenThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                child: Text(
                  invoice.identificacion,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  "Correo",
                  style: TextStyle(
                      // color: THEME.greenThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                child: Text(
                  invoice.correo,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  "Teléfono",
                  style: TextStyle(
                      // color: THEME.greenThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                child: Text(
                  invoice.telefono,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                child: Text(
                  "Dirección",
                  style: TextStyle(
                      // color: THEME.greenThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                child: Text(
                  invoice.direccion,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                'Cerrar',
                style: TextStyle(color: THEME.blackThemeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            )
          ],
        );
      },
    );
  }

  static Future<ConfirmAction> asyncContactoDialog(BuildContext context,
      String nombreContacto, String contacto, Function openWs) async {
    String _contacto = contacto.replaceAll('+', '');

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Contactar a',
                style: TextStyle(color: THEME.greenThemeColor, fontSize: 12.0),
              ),
              Text(
                nombreContacto,
                style: TextStyle(color: THEME.blackThemeColor, fontSize: 24.0),
              )
            ],
          ),
          contentPadding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 4.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  launch("tel://$contacto");
                },
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          // size: 100,
                          // color: Color(0xFF25D366),
                        ),
                        Text('Llamar', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: THEME.blackThemeColor,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    FlutterOpenWhatsapp.sendSingleMessage(_contacto, ""),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.whatsapp,
                          // size: 100,
                          // color: Color(0xFF25D366),
                        ),
                        Text('Whatsapp', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                'Cerrar',
                style: TextStyle(color: THEME.blackThemeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            )
          ],
        );
      },
    );
  }
}
