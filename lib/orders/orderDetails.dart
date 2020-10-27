import 'package:ecodelivery/components/LabelTitle.dart';
import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Producto.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/productoDetails.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ecodelivery/components/Input.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class OrderDetailsPage extends StatefulWidget {
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProgressDialog pr;

  TextEditingController notasController = new TextEditingController();

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, String title,
      String mensaje, String acceptText, String cancelText) async {
    List<String> mensajes = ['15min', '30min', '45m', '1h'];

    Order order =
        Provider.of<OrderProvider>(context, listen: false).orderForDetails;

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: THEME.greenThemeColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(mensaje),
                if (order.estado == 'pending') ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 4.0),
                    child: new Text(
                      'Notas para el cliente',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: <Widget>[
                      ...mensajes.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                notasController.text =
                                    'Preparando en ${e} apróximadamente.';
                              },
                              child: Chip(
                                label: Text(e),
                              ),
                            ),
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                    child: Input(
                      label: 'Notas',
                      controller: notasController,
                      hintText: 'Tu pedido sale en...',
                      maxLines: 2,
                    ),
                  )
                ]
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                cancelText,
                style: TextStyle(color: THEME.blackThemeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: new Text(
                acceptText,
                style: TextStyle(color: THEME.greenThemeColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  _updateOrderState(estado) async {
    Order order =
        Provider.of<OrderProvider>(context, listen: false).orderForDetails;

    await pr.show();

    var responseJson;

    order.estado = estado;
    responseJson = await OrderService.updateState(order, notasController.text);

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

  @override
  Widget build(BuildContext context) {
    pr = createBlackProgressDialog(context);
    pr.style(message: 'Aceptando pedido.');
    //Padding de opciones de categorias
    var productCardHeight = 150.0;

    Order order =
        Provider.of<OrderProvider>(context, listen: false).orderForDetails;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Detalles del pedido'),
        backgroundColor: THEME.blackThemeColor,
      ),
      bottomNavigationBar:
          order.estado == 'pending' || order.estado == 'processing'
              ? Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[...buildButtons(order)],
                    ),
                  ))
              : null,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: ['pending', 'order-ready'].indexOf(order.estado) == -1
                ? const EdgeInsets.all(4.0)
                : const EdgeInsets.all(8.0),
            child: Center(
                child: Image.asset(
              ['completed', 'cancelled'].indexOf(order.estado) == -1
                  ? "assets/${order.estado}.gif"
                  : "assets/${order.estado}.png",
              width: ['pending', 'order-ready'].indexOf(order.estado) == -1
                  ? 125
                  : 110,
            )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'ID pedido',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: THEME.blackThemeColor,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' #${order.idOrden}',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))
                  ])),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: THEME.greenThemeColor,
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: order.status,
                                  // style: TextStyle(fontSize: 17),
                                ),
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Icon(
                                      Icons.help_outline,
                                      size: 16.0,
                                      color: THEME.greenThemeColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )))
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(color: Colors.black),
          ),
          ListTile(
            leading: Image(
              height: productCardHeight,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topRight,
              image: NetworkImage(order.portadaComercio),
            ),
            title: Text(
              order.comercio,
              style: TextStyle(
                  color: THEME.greenThemeColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(color: Colors.black),
          ),
          LabelTitle(
            title: 'Detalles del pedido',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildProductDetails(order.productos),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.moneyBill, size: 30.0),
            title: Text(
              "Pago en efectivo",
              style: TextStyle(
                  color: THEME.greenThemeColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(color: Colors.black),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, size: 30.0),
            title: Text(
              DateFormat('dd/MM/yyyy').format(order.fechaPedido),
              style: TextStyle(
                  color: THEME.greenThemeColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(color: Colors.black),
          ),
          ListTile(
            leading: Icon(Icons.access_time, size: 30.0),
            title: Text(
              '${new DateFormat("hh:mm a").format(order.fechaPedido)}',
              style: TextStyle(
                  color: THEME.greenThemeColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Divider(color: Colors.black),
          ),
          ListTile(
            onTap: () async {
              UiUtils.asyncInvoiceInfoDialog(context, order.invoice);
            },
            leading: Icon(Icons.receipt, size: 30.0),
            trailing: Icon(
              Icons.chevron_right,
            ),
            title: Text(
              'Datos de facturación',
              style: TextStyle(
                  color: THEME.greenThemeColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          LabelTitle(
            title: 'Notas adicionales',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Text(order.notas, style: TextStyle(fontSize: 17.5)),
          ),
          LabelTitle(
            title: 'Valores de la transacción',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Valor del pedido',
                          style: TextStyle(
                            color: THEME.blackThemeColor,
                            fontSize: 20.0,
                            // fontWeight: FontWeight.bold,
                          )),
                      Text('\$${order.totalOrden}',
                          style: TextStyle(
                            color: THEME.blackThemeColor,
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                //   child: Row(
                //     mainAxisAlignment:
                //         MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Text('Valor de entrega',
                //           style: TextStyle(
                //             color: THEME.blackThemeColor,
                //             fontSize: 20.0,
                //             // fontWeight: FontWeight.bold,
                //           )),
                //       Text('\$${order.valorEnvio}',
                //           style: TextStyle(
                //             color: THEME.blackThemeColor,
                //             fontSize: 18.0,
                //             // fontWeight: FontWeight.bold,
                //           ))
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('TOTAL',
                          style: TextStyle(
                            color: THEME.blackThemeColor,
                            fontSize: 20.0,
                            // fontWeight: FontWeight.bold,
                          )),
                      Text('\$${order.totalOrden}',
                          style: TextStyle(
                            color: THEME.blackThemeColor,
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildButtons(Order order) {
    if (order.estado == 'pending') {
      return [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.fromLTRB(14.0, 0, 2.5, 5.0),
            height: 60,
            child: GestureDetector(
              onTap: () async {
                var response = await _asyncConfirmDialog(
                    context,
                    'Aceptar pedido',
                    'Al confimar este pedido estas aceptando nuestros términos y condiciones.',
                    'ACEPTAR',
                    'CANCELAR');
                if (response == ConfirmAction.ACCEPT) {
                  _updateOrderState('processing');
                }
              },
              child: Material(
                  // color: Colors.white,

                  color: THEME.greenThemeColor,
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(5.0),
                  shadowColor: Color(0x802196F3),
                  child: Center(
                    child: Text('ACEPTAR \$${order.totalOrden}',
                        style: TextStyle(
                          fontSize: 20.0,
                          // color: THEME.greenThemeColor,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  )),
            ),
          ),
        ),
        Expanded(
            child: GestureDetector(
          onTap: () async {
            var response = await _asyncConfirmDialog(context, 'Cancelar pedido',
                '¿Estás seguro de cancelar este pedido?', 'SÍ', 'NO');
            if (response == ConfirmAction.ACCEPT) {
              _updateOrderState('cancelled');
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(2.5, 0, 14.0, 5.0),
            height: 60,
            child: Material(
                color: Colors.redAccent,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(5.0),
                shadowColor: Color(0x802196F3),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30.0,
                  ),
                )),
          ),
        ))
      ];
    } else if (order.estado == 'processing') {
      return [
        Expanded(
          // flex: 3,
          child: Container(
            padding: EdgeInsets.fromLTRB(14.0, 0, 14.0, 5.0),
            height: 60,
            child: GestureDetector(
              onTap: () async {
                var response = await _asyncConfirmDialog(
                    context,
                    'Orden lista',
                    'Confirma si tu orden ya está lista. Nosotros vamos por ella.',
                    'CONFIRMAR',
                    'CANCELAR');
                if (response == ConfirmAction.ACCEPT) {
                  _updateOrderState('order-ready');
                }
              },
              child: Material(
                  color: THEME.greenThemeColor,
                  elevation: 14.0,
                  borderRadius: BorderRadius.circular(5.0),
                  shadowColor: Color(0x802196F3),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'ORDEN LISTA',
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.check_box,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        )
      ];
    }
    return [];
  }

  Widget buildProductDetails(List<Producto> productos) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ...productos.map((itemProducto) => Card(
              child: ListTile(
                leading: Text("${itemProducto.quantity} x",
                    style: TextStyle(
                        fontSize: 18,
                        color: THEME.greenThemeColor,
                        fontWeight: FontWeight.bold)),
                title: SizedBox(
                    // height: 80,
                    child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Text(
                          itemProducto.name,
                          style: TextStyle(fontSize: 18),
                        )),
                    // Expanded(
                    //   flex: 1,
                    //   child: Center(
                    //       child: Text('Total', style: TextStyle(fontSize: 18))),
                    // ),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                              "\$${itemProducto.quantity * num.parse(itemProducto.price)}",
                              style: TextStyle(fontSize: 18)),
                        ))
                  ],
                )),
                onTap: () {
                  Provider.of<ProductoDetalleProvider>(context, listen: false)
                      .setProductoDetalle(itemProducto);
                  Navigator.of(context).pushNamed('/producto-detalle');
                },
                trailing: Icon(Icons.chevron_right),
              ),
            ))
      ],
    );

    // return Column(children: <Widget>[

    // ],)
  }
}
