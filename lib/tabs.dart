import 'package:ecodelivery/locations/location.dart';
import 'package:ecodelivery/marketplace/ordering.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/orders/orders.dart';
import 'package:ecodelivery/orders/pendientes.dart';
import 'package:ecodelivery/profile/profile.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/UsuarioService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './marketplace/marketplace.dart' as marketplace;
// import './orders/porAceptar.dart';
import './orders/preparando.dart';
import './orders/despachados.dart';

import './constants/theme.dart' as THEME;

// TODO: hacer que el tab de ordenes tenga badge de ordenes activas
// animaciones de ordenando

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  TabController controller;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;
    _saveDeviceToken(usuario);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _saveDeviceToken(Usuario usuario) async {
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      await UsuarioService.updateFcmToken(
          {'idUsuario': usuario.idUsuario, 'fcmToken': fcmToken});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // appBar: new AppBar(
        //   title: new Text("Ecodelivery"),
        //   backgroundColor: THEME.blackThemeColor,
        // ),
        bottomNavigationBar: new Material(
            // color: Colors.deepOrange,
            // shadowColor: THEME.greenThemeColor,

            child: new TabBar(
                controller: controller,
                indicatorColor: THEME.greenThemeColor,
                labelColor: THEME.blackThemeColor,
                tabs: <Tab>[
              new Tab(
                  text: 'Pendientes',
                  icon: new Icon(
                    Icons.notifications_active,
                    color: THEME.greenThemeColor,
                  )),
              new Tab(
                  text: 'Preparando',
                  icon: new Icon(
                    Icons.shopping_basket,
                    color: THEME.greenThemeColor,
                  )),
              // new Tab(
              //     icon: new Icon(
              //   Icons.room,
              //   color: THEME.greenThemeColor,
              // )),
              new Tab(
                  text: 'Despachados',
                  icon: new Icon(
                    Icons.send,
                    color: THEME.greenThemeColor,
                  )),
            ])),
        body: new TabBarView(controller: controller, children: <Widget>[
          new PendientesPorAceptarPage(),
          new PedidiosPreparandoPage(),
          new PedidiosDespachadosPage(),
        ]));
  }
}
