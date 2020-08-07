import 'package:ecodelivery/auth/login.dart';
import 'package:ecodelivery/providers/cart.dart';
import 'package:ecodelivery/providers/location.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/providers/productoDetails.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/providers/invoice.dart';
import 'package:ecodelivery/providers/order.dart';
import 'package:ecodelivery/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => SessionInfoProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => MarketProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => InvoiceProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => OrderProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductoDetalleProvider(),
      )
    ], child: Routes());
  }
}

// Routes()
