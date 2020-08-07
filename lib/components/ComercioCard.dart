// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/theme.dart' as THEME;

class ComercioCard extends StatelessWidget {
  ComercioCard(
      {@required this.nombre, @required this.portada, @required this.onPress});

  final nombre;
  final portada;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        height: 190,
        child: Material(
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
                      image: NetworkImage(this.portada),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    child: getDetails(),
                  ),
                ),
              ],
            )),
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
}
