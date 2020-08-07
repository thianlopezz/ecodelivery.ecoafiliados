import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class OrderingPage extends StatefulWidget {
  @override
  _OrderingPageState createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: new Scaffold(
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
                    "Ordenando",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: THEME.greenThemeColor,
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/success'),
                    child: Icon(
                      Icons.alarm,
                      size: 70,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "La tienda está verificando y aceptando tu pedido.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: THEME.blackThemeColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Esto no tardará mucho.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: THEME.blackThemeColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Estas ordenando'),
          content: Text('Espera que el establecimiento responda'),
          // actions: [
          //   FlatButton(
          //     child: Text('Yes'),
          //     onPressed: () => Navigator.pop(c, true),
          //   ),
          //   FlatButton(
          //     child: Text('No'),
          //     onPressed: () => Navigator.pop(c, false),
          //   ),
          // ],
        ),
      ),
    );
  }
}
