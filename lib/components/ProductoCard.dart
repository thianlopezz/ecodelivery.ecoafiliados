// Flutter
import 'package:ecodelivery/providers/cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;
import 'package:ecodelivery/models/Producto.dart';

class ProductoCard extends StatelessWidget {
  ProductoCard(
      {@required this.type,
      @required this.nombre,
      @required this.foto,
      @required this.precio,
      @required this.stockStatus,
      @required this.featured,
      this.variaciones,
      @required this.onDetail,
      @required this.onChangeStatus,
      @required this.onFeature,
      this.loading});

  final String type;
  final String nombre;
  final String foto;
  final String precio;
  final String stockStatus;
  final bool featured;
  final Function onDetail;
  final Function onChangeStatus;
  final Function onFeature;
  final List<Producto> variaciones;

  final bool loading;

  final productCardHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: productCardHeight,
      child: Stack(
        children: <Widget>[
          Material(
              color: Colors.white,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: onDetail,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: Image(
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            image: NetworkImage(foto),
                          ),
                        ),
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
          Positioned(
            right: 4.0,
            bottom: 4.0,
            child: IconButton(
              onPressed: () => this.onFeature(!featured),
              color: Colors.yellow,
              icon: Icon(featured ? Icons.star : Icons.star_border,
                  color: THEME.greenThemeColor),
            ),
          )
        ],
      ),
    );
  }

  Widget myDetailsContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: onDetail,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: THEME.greenThemeColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
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
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Center(
            child: !loading
                ? Row(
                    children: <Widget>[
                      Switch(
                        value: stockStatus == 'instock',
                        activeColor: THEME.greenThemeColor,
                        onChanged: (value) => onChangeStatus(value),
                      ),
                      Text(
                        stockStatus == 'instock' ? 'En stock' : 'Agotado',
                        style: TextStyle(
                            fontSize: 17.5, color: THEME.blackThemeColor),
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}
