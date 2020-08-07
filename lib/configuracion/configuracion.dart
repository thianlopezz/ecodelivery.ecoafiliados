import 'package:ecodelivery/components/OrderCard.dart';
import 'package:ecodelivery/models/Order.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/OrderService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class ConfiguracionPage extends StatefulWidget {
  @override
  _ConfiguracionPageState createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _getOders();
    // });
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
            child: Center(
                child: Row(
              children: <Widget>[
                Text('Abierto'),
                Switch(
                  value: true,
                  onChanged: (value) => print('a'),
                )
              ],
            )),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Text('Abierto'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
