import 'package:ecodelivery/components/OrderCard.dart';
import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class ListosPage extends StatefulWidget {
  @override
  _ListosPageState createState() => _ListosPageState();
}

class _ListosPageState extends State<ListosPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<List<Order>> ordenes;

  List<Order> orderList;
  List<Order> ordersFiltered;

  Usuario usuario;

  var error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOders();
    });
  }

  Future<Null> _getOders() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    ordenes = OrderService.getOrders(usuario.idComercio, 'order-ready');
    // var ordenList = await ordenes;
    return ordenes.then((ordenList) {
      setState(() {
        this.orderList = ordenList;
        ordersFiltered = ordenList;
      });
    }).catchError((e) {
      setState(() {
        error = e;
      });
    });
    // comerciosFilterd = comercios.

    // return ordenes;
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    return new Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _getOders,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                child: FutureBuilder<List<Order>>(
              future: ordenes,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 1.6,
                        child: Center(child: Text("${snapshot.error}"))),
                  );
                } else if (snapshot.hasData &&
                    ordersFiltered != null &&
                    ordersFiltered.length > 0) {
                  return ListView(
                      scrollDirection: Axis.vertical,
                      children: ordersFiltered
                          .map((orden) => new Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: OrderCard(
                                nombreUsuario: orden.nombre,
                                valorDelPedido: orden.totalOrden,
                                cantidadItems: orden.productos.length,
                                date: orden.fechaPedido,
                                onPress: () async {
                                  Provider.of<OrderProvider>(
                                          _scaffoldKey.currentContext,
                                          listen: false)
                                      .setOrderForDetails(orden);
                                  await Navigator.of(context)
                                      .pushNamed('/order-details');
                                  _getOders();
                                },
                              )))
                          .toList());
                } else if (ordersFiltered != null &&
                    snapshot.data != null &&
                    snapshot.data.length == 0) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: Center(
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
                            "No tienes pedidos listos.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              'Aquí encontrarás los pedidos que están listos para ser entregados.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )),
                    ),
                  );
                }

                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            )),
          ],
        ),
      ),
    );
  }
}
