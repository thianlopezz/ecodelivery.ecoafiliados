import 'package:ecodelivery/components/CustomAppBar.dart';
import 'package:ecodelivery/components/OrderCard.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/orders/orderDetails.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/ComercioService.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class PendientesPorAceptarPage extends StatefulWidget {
  @override
  _PendientesPorAceptarPageState createState() =>
      _PendientesPorAceptarPageState();
}

class _PendientesPorAceptarPageState extends State<PendientesPorAceptarPage> {
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
    getComercio();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOders();
    });
  }

  getComercio() async {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;
    try {
      Comercio comercio =
          await ComercioService.getComercio('${usuario.idComercio}');
      Provider.of<MarketProvider>(context, listen: false).setComercio(comercio);
    } catch (e) {
      print(e);
    }
  }

  setHighRequested(int value) async {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;
    try {
      dynamic response = await ComercioService.setHighRequested(
          '${usuario.idComercio}', value);
      getComercio();
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _getOders() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    ordenes = OrderService.getOrders(usuario.idComercio, 'pending');
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

    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: true).comercio;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        elevation: 0,
        title: Text(
          'Pendientes',
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
        bottom: CustomAppBar(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 16),
            child: Row(
              children: <Widget>[
                Switch(
                  value: (comercio != null &&
                      comercio.highRequested == 1 &&
                      comercio.isOpen == 1),
                  activeColor: Colors.redAccent,
                  onChanged: (value) => setHighRequested(value ? 1 : 0),
                ),
                RichText(
                  text: TextSpan(
                    style:
                        TextStyle(fontSize: 17.5, color: THEME.blackThemeColor),
                    children: [
                      TextSpan(
                        text: (comercio != null &&
                                comercio.highRequested == 1 &&
                                comercio.isOpen == 1)
                            ? 'En alta demanda'
                            : 'Activar alta demanda',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                } else if (ordersFiltered != null &&
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
                                // date: orden.fechaPedido.toLocal(),
                                date: orden.fechaPedido,
                                onPress: () async {
                                  Provider.of<OrderProvider>(
                                          _scaffoldKey.currentContext,
                                          listen: false)
                                      .setOrderForDetails(orden);
                                  // await Navigator.of(context)
                                  //     .pushNamed('/order-details');

                                  await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new OrderDetailsPage(),
                                          fullscreenDialog: true));
                                  _getOders();
                                },
                              )))
                          .toList());
                } else if (ordersFiltered != null &&
                    ordersFiltered.length == 0) {
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
                            "No tienes pedidos pendientes por aceptar.",
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
                              'No desesperes nosotros nos encargamos de conectarte con tus clientes.',
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
