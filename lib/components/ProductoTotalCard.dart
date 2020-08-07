// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/theme.dart' as THEME;

class ProductoTotalCard extends StatelessWidget {
  ProductoTotalCard(
      {@required this.nombre,
      @required this.foto,
      @required this.precio,
      @required this.cantidad,
      @required this.onPressAdd,
      @required this.onPressRemove});

  final String nombre;
  final String foto;
  final String precio;
  final int cantidad;
  final Function onPressAdd;
  final Function onPressRemove;

  final productCardHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: productCardHeight,
      child: Stack(
        children: <Widget>[
          Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        height: 200,
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                        image: NetworkImage(foto),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      child: myDetailsContainer(),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
            child: ClipOval(
              child: Material(
                color: THEME.greenThemeColor, // button color
                child: InkWell(
                  splashColor: THEME.greenThemeColor, // inkwell color
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                          child: Text(
                        '${cantidad}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))),
                  onTap: () {},
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getDetails() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Text(
          this.nombre,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: THEME.greenThemeColor,
              fontSize: 24.0,
              fontWeight: FontWeight.bold),
        )),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.mapPin,
              color: THEME.blackThemeColor,
            ),
            Text(
              "A 3.3km de ti",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )
          ],
        )),
      ],
    );
  }

  Widget myDetailsContainer() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: nombre + "\n",
                    style: TextStyle(
                        color: THEME.greenThemeColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\$" + precio,
                    style: TextStyle(
                        color: THEME.blackThemeColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " 1 unidad",
                    style: TextStyle(
                        color: Colors.black38, fontWeight: FontWeight.bold),
                  )
                ],
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
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: onPressRemove,
                          elevation: 2.0,
                          fillColor: THEME.blackThemeColor,
                          child: Icon(
                            Icons.remove,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          // padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            '${cantidad}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: onPressAdd,
                          elevation: 2.0,
                          fillColor: THEME.blackThemeColor,
                          child: Icon(
                            Icons.add,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          // padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('\$${double.parse(precio) * cantidad}',
                      style: TextStyle(
                          color: THEME.blackThemeColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
