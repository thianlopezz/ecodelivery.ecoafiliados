import 'package:ecodelivery/components/ProgressDialog.dart';
import 'package:ecodelivery/components/Input.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/LocationService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:ecodelivery/providers/location.dart';
import 'package:ecodelivery/models/Location.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class LocationFormPage extends StatefulWidget {
  LocationFormPage(BuildContext context) {}

  @override
  _LocationFormPageState createState() => _LocationFormPageState();
}

class _LocationFormPageState extends State<LocationFormPage> {
  int _idUbicacion;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final Map<String, Marker> _markers = {};
  Position currentLocation =
      new Position(latitude: -0.8990336, longitude: -89.6098055);

  LatLng positionToSave = new LatLng(-0.8990336, -89.6098055);

// Completer<GoogleMapController> _controllerMap = Completer();
  GoogleMapController _controllerMap;

  TextEditingController nombreUbicacionController = TextEditingController();
  TextEditingController referenciaController = TextEditingController();

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStuff();
    });
    // _getLocation();
  }

  _save(locationInfo) async {
    if (_formKey.currentState.validate()) {
      // _showLoading();

      await pr.show();

      var responseJson;

      if (locationInfo['idUbicacion'] == null) {
        responseJson = await LocationService.saveNewLocation(locationInfo);
      } else {
        responseJson = await LocationService.updateLocation(locationInfo);
      }

      print(responseJson);

      if (responseJson == null) {
        await pr.hide();
        UiUtils.showSnackBar(
            _scaffoldKey, 'Algo Salió mal, vuelve a intentarlo luego.');
      } else if (responseJson == 'NetworkError') {
        await pr.hide();
        UiUtils.showSnackBar(_scaffoldKey, null);
      } else if (!responseJson['success']) {
        await pr.hide();
        UiUtils.showSnackBar(_scaffoldKey, responseJson['mensaje']);
      } else {
        // pr.update(message: responseJson['mensaje']);

        await pr.hide();

        Navigator.pop(context, responseJson['mensaje']);
      }
    }
  }

  void _initStuff() {
    Location locationFromProvider = Provider.of<LocationProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .location;

    if (locationFromProvider != null &&
        locationFromProvider.idUbicacion != null) {
      setState(() {
        _idUbicacion = locationFromProvider.idUbicacion;
        nombreUbicacionController =
            TextEditingController(text: locationFromProvider.nombre);
        referenciaController =
            TextEditingController(text: locationFromProvider.referencia);

        currentLocation = new Position(
            latitude: locationFromProvider.longitud,
            longitude: locationFromProvider.latitud);

        _centerMarker(new LatLng(
            locationFromProvider.latitud, locationFromProvider.longitud));
        positionToSave =
            new LatLng(currentLocation.latitude, currentLocation.longitude);

        if (_controllerMap != null) {
          _controllerMap.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: new LatLng(
                    currentLocation.latitude, currentLocation.longitude),
                zoom: 18),
          ));
        }
      });
    } else {
      _getLocation();
    }
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    if (_controllerMap != null) {
      _controllerMap.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: new LatLng(
              currentLocation.latitude,
              currentLocation.longitude,
            ),
            zoom: 18),
      ));
    }

    setState(() {
      _centerMarker(
          new LatLng(currentLocation.latitude, currentLocation.longitude));
      this.currentLocation = currentLocation;
      positionToSave =
          new LatLng(currentLocation.latitude, currentLocation.longitude);
    });
  }

  void _centerMarker(LatLng center) {
    _markers.clear();
    final marker = Marker(
      markerId: MarkerId("Ubicación"),
      position: LatLng(center.latitude, center.longitude),
    );
    _markers["Current Location"] = marker;
  }

  @override
  Widget build(BuildContext context) {
    pr = createBlackProgressDialog(context);
    pr.style(message: 'Guardando.');

    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    return new Scaffold(
        key: _scaffoldKey,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => _getLocation(),
        //   tooltip: 'Get Location',
        //   child: Icon(Icons.person_pin_circle),
        // ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Stack(
                children: <Widget>[
                  _buildGoogleMap(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
                    child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 27.0,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: FloatingActionButton(
                        backgroundColor: THEME.greenThemeColor,
                        onPressed: () => _getLocation(),
                        tooltip: 'Mi ubicación',
                        child: Icon(Icons.my_location),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  // height: 100.0,
                  margin: const EdgeInsets.only(top: 6.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 4.0, 8.0),
                          child: Center(
                            child: Text(
                                'Selecciona la ubicación en el mapa y llena los datos.'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          child: Input(
                              label: 'Nombre de la ubicación',
                              controller: nombreUbicacionController,
                              hintText: 'Ej: Mi casa, mi trabajo',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa el nombre de esta ubicación';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Input(
                              label: 'Referencia',
                              controller: referenciaController,
                              hintText:
                                  'Ej: casa del señor..., frente al mercado',
                              maxLines: 3,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Ingresa la referencia de esta ubicación';
                                }
                                return null;
                              }),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  var locationInfo = {
                                    "idUbicacion": _idUbicacion,
                                    "idUsuario": usuario.idUsuario,
                                    "nombreUbicacion":
                                        nombreUbicacionController.text,
                                    "referencia": referenciaController.text,
                                    "latitud": positionToSave.latitude,
                                    "longitud": positionToSave.longitude,
                                  };

                                  _save(locationInfo);
                                },
                                color: THEME.greenThemeColor,
                                child: Text('Guardar',
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      height: double.infinity,
      width: double.infinity,
      child: GoogleMap(
        zoomGesturesEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 3),
        onCameraMove: (CameraPosition) {
          setState(() {
            _centerMarker(CameraPosition.target);
            currentLocation = Position(
                latitude: CameraPosition.target.latitude,
                longitude: CameraPosition.target.longitude);
            positionToSave = CameraPosition.target;
          });
        },
        onMapCreated: (GoogleMapController controller) {
          // _controllerMap.complete(controller);
          _controllerMap = controller;
        },
        markers: _markers.values.toSet(),
        // markers: _listMarker(),
      ),
    );
  }
}
