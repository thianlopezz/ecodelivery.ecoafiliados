import 'package:ecodelivery/components/OrderCard.dart';
import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/orders/listos.dart';
import 'package:ecodelivery/orders/orderDetails.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class PedidiosDespachadosPage extends StatefulWidget {
  @override
  _PedidiosDespachadosPageState createState() =>
      _PedidiosDespachadosPageState();
}

class _PedidiosDespachadosPageState extends State<PedidiosDespachadosPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorReady =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorHist =
      new GlobalKey<RefreshIndicatorState>();

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

  Future<Null> _getOders() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    ordenes = OrderService.getOrders(usuario.idComercio, 'order-ready');
    List<Order> ordenesListas = await ordenes;

    ordenes = OrderService.getOrders(usuario.idComercio, 'hold-con');
    List<Order> ordenesHoldOn = await ordenes;

    ordenes = OrderService.getOrders(usuario.idComercio, 'completed');
    List<Order> ordenesCompleted = await ordenes;

    ordenes = OrderService.getOrders(usuario.idComercio, 'cancelled');
    List<Order> ordenesCancelled = await ordenes;

    // comerciosFilterd = comercios.
    setState(() {
      this.orderList = [
        ...ordenesListas,
        ...ordenesHoldOn,
        ...ordenesCompleted,
        ...ordenesCancelled
      ];

      ordersFiltered = this.orderList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            elevation: 0,
            title: Text(
              'Despachados',
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
            bottom: TabBar(
              indicatorColor: THEME.greenThemeColor,
              tabs: [
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: 'Listos',
                ),
                Tab(
                  // icon: Icon(Icons.directions_transit),
                  text: 'Historial',
                ),
              ],
            )),
        body: TabBarView(
          children: <Widget>[
            ListosPage(),
            RefreshIndicator(
              key: _refreshIndicatorHist,
              onRefresh: _getOders,
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: FutureBuilder<List<Order>>(
                    future: ordenes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          ordersFiltered != null &&
                          ordersFiltered.length > 0) {
                        return ListView(
                            scrollDirection: Axis.vertical,
                            children: ordersFiltered
                                .where((or) =>
                                    or.estado == 'hold-on' ||
                                    or.estado == 'completed')
                                .toList()
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

                                        await Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new OrderDetailsPage(),
                                                fullscreenDialog: true));
                                      },
                                    )))
                                .toList());
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
            ),
          ],
        ),
      ),
    );
  }
}
