import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/orders/orderDetails.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:ecodelivery/components/OrderCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class PedidiosPreparandoPage extends StatefulWidget {
  @override
  _PedidiosPreparandoPageState createState() => _PedidiosPreparandoPageState();
}

class _PedidiosPreparandoPageState extends State<PedidiosPreparandoPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    ordenes = OrderService.getOrders(usuario.idComercio, 'processing');
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
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0,
        title: Text(
          'Preparando',
        ),
        backgroundColor: THEME.blackThemeColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.of(context).pushNamed('/profile');
              },
              child: Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 47,
                    height: 47,
                    child: Container(
                        // width: double.infinity,
                        // height: double.infinity,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(usuario.foto != null
                                    ? usuario.foto
                                    : "http://tienda.ecodelivery.org/wp-content/uploads/2020/05/comida-pp.png")))),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _getOders,
        child: Column(
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
                                  // await Navigator.of(context)
                                  //     .pushNamed('/order-details');

                                  //TODO: poner en tab siguiente
                                  await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new OrderDetailsPage(),
                                          fullscreenDialog: true));
                                  _getOders();
                                },
                              )))
                          .toList()

                      // <Widget>[
                      //   Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: ComercioCard(onPress: () => Navigator.of(context).pushNamed('/tienda'),),
                      //   )],
                      );
                } else if (ordersFiltered != null &&
                    snapshot.data != null &&
                    snapshot.data.length == 0) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.3,
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
                            "No tienes pedidios preparando.",
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
                              'Los pedidos que aceptes y esten siendo preparados, los encontrarás aquí.',
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
