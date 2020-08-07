import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:ecodelivery/components/OrderCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<Order>> ordenes;

  List<Order> orderList;
  List<Order> ordersFiltered;

  Usuario usuario;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOders();
    });
  }

  _getOders() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    ordenes = OrderService.getOrders(usuario.idComercio, 'processing');
    var ordenList = await ordenes;
    // comerciosFilterd = comercios.
    setState(() {
      this.orderList = ordenList;
      ordersFiltered = ordenList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          'Mis pedidos',
        ),
        backgroundColor: THEME.blackThemeColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: FutureBuilder<List<Order>>(
                future: ordenes,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      ordersFiltered != null &&
                      ordersFiltered.length > 0) {
                    // return Text(snapshot.data.title);
                    // snapshot.data

                    return ListView(
                        scrollDirection: Axis.vertical,
                        children: ordersFiltered
                            .map((orden) => new Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: OrderCard(
                                      nombreUsuario: orden.comercio,
                                      cantidadItems: orden.cantidadItems,
                                      estado: orden.estado,
                                      // totalItems: orden.portadaComercio,
                                      valorDelPedido: orden.total,
                                      onPress: () {
                                        Provider.of<OrderProvider>(
                                                _scaffoldKey.currentContext,
                                                listen: false)
                                            .setOrderForDetails(orden);
                                        Navigator.of(context)
                                            .pushNamed('/order-details');
                                      }),
                                ))
                            .toList()

                        // <Widget>[
                        //   Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: ComercioCard(onPress: () => Navigator.of(context).pushNamed('/tienda'),),
                        //   )],
                        );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (ordersFiltered != null &&
                      snapshot.data != null &&
                      snapshot.data.length == 0) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 300,
                          image: AssetImage("assets/noOrders.png"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Aún no has realizado pedidos.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            'Empieza pedir lo que necesitas a tus establecimientos favoritos en la pestaña de "Comercios".',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ));
                  }

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                },
              )),
        ],
      ),
    );
  }
}
