// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  OrderCard(
      {@required this.nombreUsuario,
      @required this.cantidadItems,
      @required this.valorDelPedido,
      @required this.date,
      this.estado,
      this.onPress});

  final String nombreUsuario;
  final int cantidadItems;
  final String valorDelPedido;
  final DateTime date;
  final String estado;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: color,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      shadowColor: Color(0x802196F3),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: Icon(
          Icons.notifications_active,
          color: THEME.greenThemeColor,
        ),
        title: SizedBox(
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "${nombreUsuario}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: THEME.greenThemeColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text("${cantidadItems} producto(s)"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text("\$${valorDelPedido} total pedido"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.calendar_today,
                            size: 18.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      TextSpan(
                          text: '${new DateFormat("dd/MM/yyyy").format(date)}',
                          style: TextStyle(
                              color: THEME.blackThemeColor,
                              fontWeight: FontWeight.w500)

                          // style: TextStyle(fontSize: 17),
                          ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.access_time,
                            size: 18.0,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      TextSpan(
                          text: '${new DateFormat("hh:mm a").format(date)}',
                          style: TextStyle(
                              color: THEME.blackThemeColor,
                              fontWeight: FontWeight.w500)

                          // style: TextStyle(fontSize: 17),
                          ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
//          trailing: Text(record.firstName.toString()),
        onTap: this.onPress,
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget myDetailsContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "${nombreUsuario}\n",
                      style: TextStyle(
                          color: THEME.greenThemeColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "${cantidadItems} producto(s)",
                      style: TextStyle(
                          color: THEME.blackThemeColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '\$${valorDelPedido}',
                    style: TextStyle(
                        color: THEME.blackThemeColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Image.asset(
                  "assets/pending.gif",
                  // "assets/logo.png",
                  width: 150,
                )
                    // pending
                    // Text("${estado}",
                    //     style: TextStyle(
                    //         color: THEME.greenThemeColor,
                    //         fontSize: 20.0,
                    //         fontWeight: FontWeight.bold)),
                    ),
              )
            ],
          ),
        )
      ],
    );
  }
}
