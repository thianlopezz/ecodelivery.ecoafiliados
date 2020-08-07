import 'package:ecodelivery/models/Invoice.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/profile/invoiceForm.dart';
import 'package:ecodelivery/providers/invoice.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/InvoiceService.dart';
import 'package:ecodelivery/utils/UiUtils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme.dart' as THEME;

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<Invoice>> datosFacturacion;

  List<Invoice> datosfacturacionList;
  List<Invoice> datosFacturacionFiltered;

  Usuario usuario;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInvoceData();
    });
  }

  _getInvoceData() async {
    Usuario usuario = Provider.of<SessionInfoProvider>(
            _scaffoldKey.currentContext,
            listen: false)
        .usuario;
    datosFacturacion = InvoiceService.getDatosFacturacion(usuario.idUsuario);
    var datosFacturacionList = await datosFacturacion;
    // comerciosFilterd = comercios.
    setState(() {
      this.datosfacturacionList = datosFacturacionList;
      datosFacturacionFiltered = datosFacturacionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          'Facturación',
        ),
        backgroundColor: THEME.blackThemeColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          // Navigator.of(context).pushNamed('/location-form');

          Provider.of<InvoiceProvider>(context, listen: false)
              .setinvoice(new Invoice());

          var result = await Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new InvoiceFormPage(context),
                  fullscreenDialog: true));
          UiUtils.showSnackBar(_scaffoldKey, result);

          _getInvoceData();
        },
        child: Icon(Icons.add),
        backgroundColor: THEME.greenThemeColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Datos de facturación',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: FutureBuilder<List<Invoice>>(
              future: datosFacturacion,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    datosFacturacionFiltered != null &&
                    datosFacturacionFiltered.length > 0) {
                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: datosFacturacionFiltered
                        .map((datos) => ListTile(
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  Provider.of<InvoiceProvider>(context,
                                          listen: false)
                                      .setinvoice(datos);

                                  var result = await Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new InvoiceFormPage(context),
                                          fullscreenDialog: true));
                                  UiUtils.showSnackBar(_scaffoldKey, result);

                                  _getInvoceData();
                                },
                              ),
                              title: Text(
                                datos.nombre,
                                style: TextStyle(
                                    color: THEME.greenThemeColor,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${datos.correo}\n${datos.identificacion}\n${datos.direccion}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    // fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                        .toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (datosFacturacionFiltered != null &&
                    snapshot.data != null &&
                    snapshot.data.length == 0) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        width: 300,
                        image: AssetImage("assets/noInvoiceData.png"),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Aún no has registrado datos de facturación.",
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
                          'Registra nuevos datos de facturación en el botón "+"',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ));
                }

                // By default, show a loading spinner.
                return Center(child: CircularProgressIndicator());
              },
            ),
          )
        ],
      ),
    );
  }
}
