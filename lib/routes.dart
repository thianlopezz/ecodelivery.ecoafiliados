import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodelivery/auth/login.dart';
import 'package:ecodelivery/configuracion/configuracion.dart';
import 'package:ecodelivery/locations/location.dart';
import 'package:ecodelivery/locations/locationForm.dart';
import 'package:ecodelivery/marketplace/checkout.dart';
import 'package:ecodelivery/marketplace/ordering.dart';
import 'package:ecodelivery/marketplace/product-details.dart';
import 'package:ecodelivery/marketplace/success.dart';
import 'package:ecodelivery/marketplace/suelto.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/orders/orderDetails.dart';
import 'package:ecodelivery/profile/invoice.dart';
import 'package:ecodelivery/profile/profile.dart';
import 'package:ecodelivery/profile/invoiceForm.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/ComercioService.dart';
import 'package:ecodelivery/services/UsuarioService.dart';
import 'package:ecodelivery/utils/SessionUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './auth/signup.dart';
import './tabs.dart';
import './marketplace/market.dart';

class Routes extends StatefulWidget {
  @override
  _RoutesState createState() => new _RoutesState();
}

class _RoutesState extends State<Routes> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _sharedPreferences = await _prefs;
      String usuario__ = SessionUtils.getUsuario(_sharedPreferences);

      if (usuario__ != null) {
        Usuario usuario = Usuario.fromJson(jsonDecode(usuario__));
        Provider.of<SessionInfoProvider>(context, listen: false)
            .setUsuario(usuario);
        // _saveDeviceToken(usuario);
      }
    });

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  _saveDeviceToken(Usuario usuario) async {
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      await UsuarioService.updateFcmToken(
          {'idUsuario': usuario.idUsuario, 'fcmToken': fcmToken});
    }
  }

// ProfileFormPage
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      key: _scaffoldKey,
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/tabs': (BuildContext context) => new MyTabs(),
        '/checkout': (BuildContext context) => new CheckoutPage(),
        '/ordering': (BuildContext context) => new OrderingPage(),
        '/suelto': (BuildContext context) => new SueltoPage(),
        '/success': (BuildContext context) => new SuccessPage(),
        '/order-details': (BuildContext context) => new OrderDetailsPage(),
        '/location': (BuildContext context) => new LocationPage(),
        '/producto-detalle': (BuildContext context) => new ProductDetailsPage(),
        '/profile': (BuildContext context) => new ProfilePage(),

        // '/location-form': (BuildContext context) => new LocationFormPage(),
        '/invoice': (BuildContext context) => new InvoicePage(),
        '/tienda': (BuildContext context) => new MarketPage(),
        // '/invoiceForm': (BuildContext context) => new InvoiceFormPage(),
      },
      home: LoginPage(),
    );
  }
}
