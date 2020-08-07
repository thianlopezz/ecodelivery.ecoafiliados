import 'package:ecodelivery/components/LabelDescription.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/services/ComercioService.dart';
import 'package:ecodelivery/utils/AuthUtils.dart';
import 'package:ecodelivery/utils/SessionUtils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/theme.dart' as THEME;
import '../providers/sessionInfo.dart';
import 'package:ecodelivery/profile/profileForm.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    _fetchSession();
    getComercio();
  }

  _fetchSession() async {
    _sharedPreferences = await _prefs;
  }

  getComercio() async {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;
    try {
      Comercio comercio =
          await ComercioService.getComercio('${usuario.idComercio}');
      Provider.of<MarketProvider>(context, listen: false).setComercio(comercio);
    } catch (e) {
      print(e);
    }
  }

  setOpen(int value) async {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;
    try {
      dynamic response =
          await ComercioService.setOpenComercio('${usuario.idComercio}', value);
      getComercio();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: true).comercio;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          'Perfil',
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () => AuthUtils.logoutUser(
                _scaffoldKey.currentContext,
                _sharedPreferences,
                Provider.of<SessionInfoProvider>(context, listen: false)
                    .setUsuario),
            child: Container(
              padding: EdgeInsets.only(right: 15.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Salir",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  )
                ],
              )),
            ),
          ),
          // IconButton(
          //     icon: Icon(Icons.exit_to_app),
          //     color: Colors.white,
          //     onPressed: () => AuthUtils.logoutUser(
          //         _scaffoldKey.currentContext,
          //         _sharedPreferences,
          //         Provider.of<SessionInfoProvider>(context, listen: false)
          //             .setUsuario))
        ],
        backgroundColor: THEME.blackThemeColor,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(usuario.foto != null
                                  ? usuario.foto
                                  : "https://tienda.ecodelivery.org/wp-content/uploads/2020/05/comida-pp.png")))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                    child: new Text('${usuario.nombre} ${usuario.apellido}',
                        textScaleFactor: 1.5),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 0),
                  //   child: new Text(usuario.comercio),
                  // )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8.0, 16.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  usuario.comercio,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 24,
                    color: THEME.greenThemeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: Colors.white,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Color(0x802196F3),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Text(
                            (comercio != null && comercio.isOpen == 1)
                                ? 'Ahora abierto'
                                : 'Cerrado',
                            style: TextStyle(
                              fontSize: 20,
                              color: THEME.blackThemeColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Switch(
                            value: (comercio != null && comercio.isOpen == 1),
                            activeColor: THEME.greenThemeColor,
                            onChanged: (value) => setOpen(value ? 1 : 0),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(context, '/tienda');
                        // await Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             new LocationPage(),
                        //         fullscreenDialog: true));
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Mi Tienda',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: THEME.greenThemeColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8.0, 16.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Información del perfil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new ProfileFormPage(context),
                            fullscreenDialog: true));
                  },
                  child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: THEME.greenThemeColor,
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 17.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: 'Editar',
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: Colors.white,
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: Color(0x802196F3),
              child: Column(
                children: <Widget>[
                  LabelDescription(
                    label: 'Correo',
                    value: usuario.correo,
                  ),
                  LabelDescription(
                    label: 'Contacto',
                    value: usuario.contacto,
                  ),
                  LabelDescription(
                    label: 'Fecha de nacimiento',
                    value: usuario.feNacimiento != null
                        ? DateFormat('dd/MM/yyyy').format(usuario.feNacimiento)
                        : '-',
                  ),
                  LabelDescription(
                    label: 'Género',
                    value: usuario.genero == '' ? '-' : usuario.genero,
                  ),
                  LabelDescription(
                    label: 'Bio',
                    value: usuario.bio,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget myDetailsContainer2() {
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
                    text: "Mi Casa",
                    style: TextStyle(
                        color: THEME.greenThemeColor,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "5 items",
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
                  '\$6.75',
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
                child: Text("En camino",
                    style: TextStyle(
                        color: THEME.greenThemeColor,
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
