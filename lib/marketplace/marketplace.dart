import 'package:ecodelivery/components/ComercioCard.dart';
import 'package:ecodelivery/components/Select.dart';
import 'package:ecodelivery/components/SelectLocation.dart';
import 'package:ecodelivery/locations/location.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Location.dart';
import 'package:ecodelivery/providers/location.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/services/ComercioService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var loading = false;

  Future<List<Comercio>> comercios;
  List<Comercio> comerciosList;
  List<Comercio> comerciosFiltered;

  var filterController = new TextEditingController();
  String _searchText = "";

  _MarketplacePageState() {
    filterController.addListener(() {
      if (filterController.text.isEmpty) {
        setState(() {
          _searchText = "";
          comerciosFiltered = comerciosList;
        });
      } else {
        setState(() {
          _searchText = filterController.text;
          var aux = comerciosList
              .where((comercio) =>
                  comercio.nombre
                      .toUpperCase()
                      .indexOf(filterController.text.toUpperCase()) !=
                  -1)
              .toList();

          comerciosFiltered = aux;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getComercios();
  }

  _getComercios() async {
    setState(() {
      loading = true;
    });

    comercios = ComercioService.getComercios();
    var comerciosList = await comercios;
    // comerciosFilterd = comercios.
    setState(() {
      loading = false;
      this.comerciosList = comerciosList;
      comerciosFiltered = comerciosList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        // leading: Container(),
        title: Text(
          'Tiendas',
        ),
        actions: <Widget>[SelectLocation()],
        backgroundColor: THEME.blackThemeColor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 10.0),
            child: new TextField(
              controller: filterController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  // filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  hintText: "Buscar",
                  fillColor: Colors.white70),
            ),
          ),
          Expanded(
              child: FutureBuilder<List<Comercio>>(
            future: comercios,
            builder: (context, snapshot) {
              if (snapshot.hasData && comerciosFiltered != null) {
                // return Text(snapshot.data.title);
                // snapshot.data

                return ListView(
                    scrollDirection: Axis.vertical,
                    children: comerciosFiltered
                        .map((comercio) => new Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ComercioCard(
                                  nombre: comercio.nombre,
                                  portada: comercio.portada,
                                  onPress: () {
                                    // setState(() {
                                    Provider.of<MarketProvider>(context,
                                            listen: false)
                                        .setComercio(comercio);
                                    // });

                                    Navigator.pushNamed(context, '/tienda',
                                        arguments: comercio);
                                  }),
                            ))
                        .toList()

                    // <Widget>[
                    //   Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: ComercioCard(onPress: () => Navigator.of(context).pushNamed('/tienda'),),
                    //   )],
                    );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              // return Center(child: CircularProgressIndicator());

              return Center(
                  child: Image.asset(
                "assets/logo_gif.gif",
                // height: 125.0,
                width: 150.0,
              ));
            },
          )),
        ],
      ),
    );
  }
}
