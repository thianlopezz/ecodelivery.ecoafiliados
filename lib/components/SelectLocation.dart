// Flutter
import 'package:ecodelivery/locations/location.dart';
import 'package:ecodelivery/models/Location.dart';
import 'package:ecodelivery/providers/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectLocation extends StatelessWidget {
  // SelectLocation(
  //     {this.value,
  //     this.hint = '',
  //     this.onChange,
  //     @required this.options,
  //     this.helperText,
  //     this.hasError = false});

  // final value;
  // final hint;
  // final List options;
  // final onChange;
  // final helperText;
  // final hasError;

  @override
  Widget build(BuildContext context) {
    Location locationForDelivery =
        Provider.of<LocationProvider>(context, listen: true)
            .locationForDelivery;

    String routeName = ModalRoute.of(context).settings.name;

    return GestureDetector(
      onTap: () async {
        // Navigator.pushNamed(context, '/location');
        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new LocationPage(),
                fullscreenDialog: true));
      },
      child: Container(
        padding: EdgeInsets.only(right: 15.0),
        child: Center(
            child: Row(
          children: <Widget>[
            Text(
              locationForDelivery == null
                  ? 'Elige un lugar de entrega'
                  : locationForDelivery.nombre,
              style: TextStyle(
                  color: routeName == '/checkout' && locationForDelivery == null
                      ? Colors.redAccent
                      : null),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: routeName == '/checkout' && locationForDelivery == null
                  ? Colors.redAccent
                  : null,
            )
          ],
        )),
      ),
    );
  }
}

// (value) {
//         if (value.isEmpty) {
//           return 'Ingresa tu usuario o correo';
//         }
//         return null;
//       }
