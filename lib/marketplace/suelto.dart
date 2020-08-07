import 'package:ecodelivery/components/Input.dart';
import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/providers/cart.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class SueltoPage extends StatefulWidget {
  @override
  _SueltoPageState createState() => _SueltoPageState();
}

class _SueltoPageState extends State<SueltoPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  ProgressDialog pr;

  TextEditingController montoController = new TextEditingController();

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  _ordenar() async {
    dynamic orden = Provider.of<OrderProvider>(context, listen: false).orden;

    if (_radioValue == 1) {
      if (!_formKey.currentState.validate())
        return;
      else
        orden['pagaCon'] = this.montoController.text;
    } else {
      orden['pagaCon'] = orden['totalConFeeEnvio'];
    }

    await pr.show();

    var responseJson = await OrderService.saveNewOrder(orden);

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

      // Navigator.pop(context, responseJson['mensaje']);
      Navigator.of(context).pushNamed('/ordering');
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = createBlackProgressDialog(context);
    pr.style(message: 'Guardando.');

    var totalConFeeEnvio =
        Provider.of<CartProvider>(context, listen: false).totalConFeeEnvio;

    return new Scaffold(
        // resizeToAvoidBottomPadding: false,
        body: Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Pago en efectivo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: THEME.greenThemeColor,
                                fontSize: 34.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "El total de tu pedido es \$${totalConFeeEnvio}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: THEME.blackThemeColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "¿Cómo vas a pagar?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: THEME.blackThemeColor,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          title: const Text('Tengo el dinero justo.'),
                          leading: new Radio(
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              const Text('Tengo \$ '),
                              Expanded(
                                child: Input(
                                    label: 'Monto',
                                    controller: montoController,
                                    enabled: _radioValue == 1,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Ingresa un monto válido';
                                      } else if (double.parse(value) <
                                          totalConFeeEnvio) {
                                        return 'El monto debe ser mayor a \$${totalConFeeEnvio}';
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                          leading: new Radio(
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              onPressed: () {
                                _ordenar();
                              },
                              color: THEME.greenThemeColor,
                              child: Text('Ordenar ahora',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        )
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
