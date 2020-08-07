import 'package:ecodelivery/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: false).comercio;
    return new Scaffold(
        // resizeToAvoidBottomPadding: false,
        // backgroundColor: THEME.blackThemeColor,
        body: Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  comercio.nombre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: THEME.greenThemeColor,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Ha recibido tu pedido.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: THEME.blackThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.check_circle,
                  size: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Sigue de cerca el estado de tus pedidos.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: THEME.blackThemeColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Provider.of<OrderProvider>(context, listen: false)
                      //     .setOrder(order);
                    },
                    color: THEME.greenThemeColor,
                    child:
                        Text('Ver mis pedidos', style: TextStyle(fontSize: 20)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
