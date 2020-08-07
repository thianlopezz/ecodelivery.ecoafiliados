import 'dart:convert';

import 'package:ecodelivery/components/Input.dart';
import 'package:ecodelivery/components/ProductoTotalCard.dart';
import 'package:ecodelivery/components/Select.dart';
import 'package:ecodelivery/components/SelectLocation.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Invoice.dart';
import 'package:ecodelivery/models/Location.dart';
import 'package:ecodelivery/models/Producto.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/cart.dart';
import 'package:ecodelivery/providers/location.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/services/InvoiceService.dart';
import 'package:ecodelivery/services/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// TODO: validacion de productos cero
// detalle de producto con opcion de aumentar

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController notasController = new TextEditingController();

  Future<List<Location>> ubicaciones;
  List<Location> ubicacionList;

  Future<List<Invoice>> datosFacturacion;
  List<Invoice> datosfacturacionList;

  Usuario usuario;

  final tipoEntregaSelected = <bool>[
    true,
    false,
  ];

  String idUbicacionValue;
  String idDatosFacturacionValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocations();
      _getInvoceData();
    });
  }

  _getLocations() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    ubicaciones = LocationService.getUbicaciones(usuario.idUsuario);
    var ubicacionList = await ubicaciones;
    ubicacionList.sort((a, b) {
      //before -> var bdate = b.expiry;
      return a.feUltimoUso.compareTo(b
          .feUltimoUso); //to get the order other way just switch `adate & bdate`
    });

    // comerciosFilterd = comercios.
    setState(() {
      this.ubicacionList = ubicacionList;

      if (ubicacionList != null && ubicacionList.length > 0) {
        var primeraOpcion = ubicacionList.elementAt(0);
        idUbicacionValue = "${primeraOpcion.idUbicacion}";
      }
    });
  }

  _getInvoceData() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    datosFacturacion = InvoiceService.getDatosFacturacion(usuario.idUsuario);
    var datosFacturacionList = await datosFacturacion;

    datosFacturacionList.insert(
        0,
        new Invoice(
            idDatosFacturacion: 0,
            nombre: 'Consumidor Final',
            identificacion: '9999999999',
            telefono: usuario.contacto,
            correo: usuario.correo,
            direccion: '',
            feUltimoUso: new DateTime(1900)));

    datosFacturacionList.sort((a, b) {
      //before -> var bdate = b.expiry;
      return a.feUltimoUso.compareTo(b
          .feUltimoUso); //to get the order other way just switch `adate & bdate`
    });

    // comerciosFilterd = comercios.
    setState(() {
      this.datosfacturacionList = datosFacturacionList;

      if (datosFacturacionList != null && datosFacturacionList.length > 0) {
        var primeraOpcion = datosFacturacionList.elementAt(0);
        idDatosFacturacionValue = "${primeraOpcion.idDatosFacturacion}";
      } else if (datosFacturacionList != null &&
          datosFacturacionList.length > 1) {
        var primeraOpcion = datosFacturacionList.elementAt(1);
        idDatosFacturacionValue = "${primeraOpcion.idDatosFacturacion}";
      }
    });
  }

  _continueToSueltos() {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: false).comercio;

    List<Producto> productos =
        Provider.of<CartProvider>(context, listen: false).productos;

    var totalConFeeEnvio =
        Provider.of<CartProvider>(context, listen: false).totalConFeeEnvio;

    Location locationData =
        Provider.of<LocationProvider>(context, listen: false)
            .locationForDelivery;

    var tipoEntrega =
        tipoEntregaSelected[0] ? 'ESPERA_EN_PUERTA' : 'ACERCARTE_AL_CONDUCTOR';

    Invoice invoiceData = datosfacturacionList.firstWhere((item) =>
        item.idDatosFacturacion == int.parse(idDatosFacturacionValue));

    if (idDatosFacturacionValue == null || locationData == null) {
      return;
    }

    var order = {
      'idUsuario': usuario.idUsuario,
      "idComercio": comercio.idComercio,
      "nombre": usuario.nombre,
      "tipoEntrega": tipoEntrega,
      "invoice": invoiceData.toJson(),
      "location": locationData.toJson(),
      "productos":
          jsonEncode(productos.map((e) => e.toProductLineJson()).toList()),
      "pagaCon": "",
      "totalConFeeEnvio": totalConFeeEnvio,
      "notas": notasController.text
    };

    Provider.of<OrderProvider>(context, listen: false).setOrder(order);

    Navigator.of(context).pushNamed('/suelto');
  }

  @override
  Widget build(BuildContext context) {
    List<Producto> productos =
        Provider.of<CartProvider>(context, listen: false).productos;

    var totalOrden = Provider.of<CartProvider>(context, listen: false).total;

    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: false).comercio;

    Location locationForDelivery =
        Provider.of<LocationProvider>(context, listen: true)
            .locationForDelivery;

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(comercio.nombre),
          actions: <Widget>[SelectLocation()],
          backgroundColor: THEME.blackThemeColor,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                        child: Text(
                          'Detalles del pedido',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          'Mi carrito',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...this.mapProducts(
                          productos,
                          Provider.of<CartProvider>(context, listen: false)
                              .setProductos),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: Text(
                          'Opciones de entrega',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ToggleButtons(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      FontAwesomeIcons.doorClosed,
                                      // size: 30,
                                    ),
                                  ),
                                  Text('Esperar en la puerta')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      FontAwesomeIcons.motorcycle,
                                      // size: 30,
                                    ),
                                  ),
                                  Text('Acercarte al conductor')
                                ],
                              ),
                            ),
                          ],
                          onPressed: (index) {
                            setState(() {
                              if (index == 0) {
                                tipoEntregaSelected[0] = true;
                                tipoEntregaSelected[1] = false;
                              } else {
                                tipoEntregaSelected[0] = false;
                                tipoEntregaSelected[1] = true;
                              }
                            });
                          },
                          isSelected: tipoEntregaSelected,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          'Lugar de entrega',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          locationForDelivery == null
                              ? 'Elige un lugar de entrega'
                              : locationForDelivery.nombre,
                          style: TextStyle(
                              color: locationForDelivery == null
                                  ? Colors.redAccent
                                  : null),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          'Datos de facturación',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: FutureBuilder(
                          future: datosFacturacion,
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                datosfacturacionList != null) {
                              return Select(
                                value: idDatosFacturacionValue,
                                helperText: datosfacturacionList.length == 1
                                    ? 'Puedes registrar tus datos de facturación en la pantalla principal, Perfil > Datos de facturación'
                                    : null,
                                options: datosfacturacionList
                                    .map<DropdownMenuItem<String>>((datos) {
                                  return DropdownMenuItem<String>(
                                    value: '${datos.idDatosFacturacion}',
                                    child: Text(datos.nombre +
                                        ' - ' +
                                        datos.identificacion),
                                  );
                                }).toList(),
                                onChange: (String newValue) {
                                  setState(() {
                                    idDatosFacturacionValue = newValue;
                                  });
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            // By default, show a loading spinner.
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          'Notas',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                        child: Input(
                          label: 'Notas',
                          controller: notasController,
                          hintText: 'Ej: Sin vegetales, sin mayonesa, etc',
                          maxLines: 4,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          'Valores a pagar',
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Valor del pedido',
                                      style: TextStyle(
                                        color: THEME.blackThemeColor,
                                        fontSize: 20.0,
                                        // fontWeight: FontWeight.bold,
                                      )),
                                  Text('\$${totalOrden}',
                                      style: TextStyle(
                                        color: THEME.blackThemeColor,
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Valor de entrega',
                                      style: TextStyle(
                                        color: THEME.blackThemeColor,
                                        fontSize: 20.0,
                                        // fontWeight: FontWeight.bold,
                                      )),
                                  Text('\$1.50',
                                      style: TextStyle(
                                        color: THEME.blackThemeColor,
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('TOTAL',
                                      style: TextStyle(
                                        color: THEME.blackThemeColor,
                                        fontSize: 20.0,
                                        // fontWeight: FontWeight.bold,
                                      )),
                                  Text('\$${totalOrden + 1.50}',
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              _continueToSueltos();
                            },
                            color: THEME.greenThemeColor,
                            child: Text('Continuar',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  List<Widget> mapProducts(List<Producto> productos, Function setNewList) {
    List<Widget> retVal = new List<Widget>();

    retVal.addAll(productos.map((producto) {
      int indexProducto = productos
          .indexWhere((productoItem) => productoItem.id == producto.id);

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductoTotalCard(
          nombre: producto.name,
          cantidad: producto.quantity,
          foto: producto.images.length > 0
              ? producto.images[0].src
              : 'http://tienda.ecodelivery.org/wp-content/uploads/2020/05/comida-pp.png',
          precio: producto.price,
          onPressAdd: () {
            producto.quantity++;
            var nuevaLista = [...productos];
            nuevaLista[indexProducto] = producto;
            setState(() {
              setNewList(nuevaLista);
            });
          },
          onPressRemove: () {
            producto.quantity--;
            var nuevaLista = [...productos];
            nuevaLista[indexProducto] = producto;

            if (producto.quantity <= 0) {
              nuevaLista.removeAt(indexProducto);
            } else {
              nuevaLista[indexProducto] = producto;
            }
            setState(() {
              setNewList(nuevaLista);
            });
          },
        ),
      );
    }).toList());

    return retVal;
  }
}
