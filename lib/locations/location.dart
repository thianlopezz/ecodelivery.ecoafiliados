import 'package:ecodelivery/locations/locationForm.dart';
import 'package:ecodelivery/models/Location.dart';
import 'package:ecodelivery/providers/location.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/LocationService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<Location>> ubicaciones;

  List<Location> ubicacionList;
  List<Location> ubicacionesFiltered;

  Usuario usuario;

  var isEdit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocations();
    });
  }

  _getLocations() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    ubicaciones = LocationService.getUbicaciones(usuario.idUsuario);
    var ubicacionList = await ubicaciones;
    // comerciosFilterd = comercios.
    setState(() {
      this.ubicacionList = ubicacionList;
      ubicacionesFiltered = ubicacionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          'Mis ubicaciones',
        ),
        backgroundColor: THEME.blackThemeColor,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ubicacionesFiltered != null && ubicacionesFiltered.length > 0
              ? FloatingActionButton(
                  mini: true,
                  heroTag: "floating_1",
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  child: Icon(!isEdit ? Icons.edit : Icons.close),
                  backgroundColor: THEME.greenThemeColor,
                )
              : Text(''),
          SizedBox(height: 10.0),
          !isEdit
              ? FloatingActionButton(
                  heroTag: "floating_2",
                  onPressed: () async {
                    Provider.of<LocationProvider>(context, listen: false)
                        .setLocation(new Location());

                    var result = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new LocationFormPage(context),
                            fullscreenDialog: true));

                    UiUtils.showSnackBar(_scaffoldKey, result);

                    _getLocations();
                  },
                  child: Icon(Icons.add),
                  backgroundColor: THEME.greenThemeColor,
                )
              : Text('')
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  !isEdit ? 'Selecciona una ubicación' : 'Editar/eliminar',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: FutureBuilder<List<Location>>(
                future: ubicaciones,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      ubicacionesFiltered != null &&
                      ubicacionesFiltered.length > 0) {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: ubicacionesFiltered
                          .map((ubicacion) => Column(
                                children: <Widget>[
                                  ListTile(
                                    trailing: isEdit
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () async {
                                                  Provider.of<LocationProvider>(
                                                          context,
                                                          listen: false)
                                                      .setLocation(ubicacion);

                                                  var result = await Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              new LocationFormPage(
                                                                  context),
                                                          fullscreenDialog:
                                                              true));
                                                  UiUtils.showSnackBar(
                                                      _scaffoldKey, result);

                                                  _getLocations();
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () {},
                                              )
                                            ],
                                          )
                                        : null,
                                    title: Text(
                                      ubicacion.nombre,
                                      style: TextStyle(
                                          color: THEME.greenThemeColor,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      ubicacion.referencia,
                                      style: TextStyle(
                                          color: Colors.black54,
                                          // fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      if (!isEdit) {
                                        Provider.of<LocationProvider>(context,
                                                listen: false)
                                            .setLocationForDelivery(ubicacion);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 0.0, 16.0, 0.0),
                                    child: Divider(color: Colors.black),
                                  ),
                                  // Divider(color: Colors.black)
                                ],
                              ))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (ubicacionesFiltered != null &&
                      snapshot.data != null &&
                      snapshot.data.length == 0)
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          width: 300,
                          image: AssetImage("assets/emptylocation.png"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Aún no has registrado lugares de entrega.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            'Registra un lugar de entrega nuevo en el botón "+"',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ));

                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                },
              ))
        ],
      ),
    );
  }
}
