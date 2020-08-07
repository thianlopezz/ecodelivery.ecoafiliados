import 'package:ecodelivery/components/ProductoCard.dart';
import 'package:ecodelivery/components/SelectLocation.dart';
import 'package:ecodelivery/marketplace/product-details.dart';
import 'package:ecodelivery/models/Categoria.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Producto.dart';
import 'package:ecodelivery/models/Usuario.dart';
import 'package:ecodelivery/providers/cart.dart';
import 'package:ecodelivery/providers/market.dart';
import 'package:ecodelivery/providers/productoDetails.dart';
import 'package:ecodelivery/providers/sessionInfo.dart';
import 'package:ecodelivery/services/CategoriaService.dart';
import 'package:ecodelivery/services/ProductoService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecodelivery/components/CategoryList.dart';
import '../constants/theme.dart' as THEME;
import 'dart:convert';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<Producto>> productos;
  Future<List<Categoria>> categorias;

  List<Producto> productosList;
  List<Producto> productosFiltered;

  List<Categoria> categoriasList;
  List<Categoria> categoriasFiltered;

  int idSelected;

  var loading = true;

  var filterController = new TextEditingController();
  String _searchText = "";

  // Comercio comercio;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCategorias();
      _getProductos();
      Provider.of<CartProvider>(context, listen: false).setProductos([]);
    });

    filterController.addListener(() {
      if (filterController.text.isEmpty) {
        setState(() {
          _searchText = "";
          productosFiltered = productosList;
        });
      } else {
        setState(() {
          _searchText = filterController.text;
          var aux = productosList
              .where((producto) =>
                  producto.name
                          .toUpperCase()
                          .indexOf(filterController.text.toUpperCase()) !=
                      -1 ||
                  producto.description
                          .toUpperCase()
                          .indexOf(filterController.text.toUpperCase()) !=
                      -1 ||
                  producto.short_description
                          .toUpperCase()
                          .indexOf(filterController.text.toUpperCase()) !=
                      -1)
              .toList();

          productosFiltered = aux;
        });
      }
    });
  }

  _getProductos() async {
    // comercio = ModalRoute.of(_scaffoldKey.currentContext).settings.arguments;
    setState(() {
      loading = true;
    });
    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: false).comercio;
    productos = ProductoService.getProductos(comercio.idComercio);
    var productosList = await productos;

    setState(() {
      this.productosList = productosList;
      productosFiltered = productosList;
      loading = false;
    });
  }

  _getCategorias() async {
    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: false).comercio;
    categorias = CategoriaService.getCategorias(comercio.idComercio);
    List<Categoria> categoriasList = await categorias;
    // categoriasList = categoriasList.where((cat) => cat.);
    setState(() {
      this.categoriasList = categoriasList;
      categoriasFiltered = categoriasList;

      if (categoriasList != null && categoriasList.length > 0)
        idSelected = categoriasList[0].id;
    });
  }

  setStockStatus(
    int idProducto,
    String value,
  ) async {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    var index = productosList.indexWhere((prod) => prod.id == idProducto);

    // var producto = json.decode(json.encode(productosList[index]));

    productosList[index].loading = true;

    setState(() {
      productosList = [...productosList, productosList[index]];
    });

    try {
      dynamic response = await ProductoService.setStockStatus(
          '${usuario.idComercio}', '${idProducto}', value);

      productosList[index].loading = false;

      if (response['success'] == true) {
        setState(() {
          productosList[index].stock_status = value;
          productosList = [...productosList, productosList[index]];
        });

        return;
      }

      print(response);

      setState(() {
        productosList = [...productosList, productosList[index]];
      });
    } catch (e) {
      print(e);
    }
  }

  setFeatured(
    int idProducto,
    bool value,
  ) async {
    Usuario usuario =
        Provider.of<SessionInfoProvider>(context, listen: false).usuario;

    var index = productosList.indexWhere((prod) => prod.id == idProducto);

    // var producto = json.decode(json.encode(productosList[index]));

    setState(() {
      productosList = [...productosList, productosList[index]];
    });

    try {
      dynamic response = await ProductoService.setFeatured(
          '${usuario.idComercio}', '${idProducto}', value);

      if (response['success'] == true) {
        setState(() {
          productosList[index].featured = value;
          productosList = [...productosList, productosList[index]];
        });

        return;
      }

      print(response);

      setState(() {
        productosList = [...productosList, productosList[index]];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Padding de opciones de categorias

    var totalOrden = Provider.of<CartProvider>(context, listen: false).total;
    List<Producto> productosCart =
        Provider.of<CartProvider>(context, listen: true).productos;

    int cantidadItems =
        Provider.of<CartProvider>(context, listen: true).cantidadItems;

    Comercio comercio =
        Provider.of<MarketProvider>(context, listen: false).comercio;

    return new Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                backgroundColor: THEME.blackThemeColor,
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    comercio != null && comercio.portada != null
                        ? comercio.portada
                        : 'https://tienda.ecodelivery.org/wp-content/uploads/2020/05/comida-pp.png',
                    fit: BoxFit.cover,
                  ),
                  // centerTitle: true,
                  title: Text(
                    comercio.nombre,
                  ),
                )),
            SliverAppBar(
                backgroundColor: Colors.white,
                // expandedHeight: 200.0,
                leading: new Container(),
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: new TextField(
                      controller: filterController,
                      decoration: new InputDecoration(
                          contentPadding: new EdgeInsets.all(8.0),
                          focusedBorder: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: THEME.greenThemeColor),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(50.0),
                            ),
                          ),
                          prefixIcon: new Icon(Icons.search),
                          border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: THEME.greenThemeColor),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(50.0),
                            ),
                          ),
                          // filled: true,
                          hintStyle: new TextStyle(color: Colors.grey[800]),
                          hintText: "Buscar",
                          fillColor: Colors.white70),
                    ),
                  ),
                )),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    color: Colors.white,
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    shadowColor: Color(0x802196F3),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            comercio.direccion,
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300),
                          ),
                          Text(
                            'Abierto hoy 18:00 a 22:00',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w300),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 16, 4),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: THEME.greenThemeColor,
                                              // fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child: Icon(
                                                  Icons.place,
                                                  size: 16.0,
                                                  color: THEME.greenThemeColor,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${comercio.distancia != null ? ('${comercio.distancia}m') : '-'}',
                                              // style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ))),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF2F2F2),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 16, 4),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: THEME.greenThemeColor,
                                              // fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                child: Icon(
                                                  Icons.star,
                                                  size: 16.0,
                                                  color: THEME.greenThemeColor,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: '5',
                                              // style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (categoriasFiltered != null && categoriasFiltered.length > 1)
                  CategoryList(
                    categorias: categoriasFiltered,
                    idSelected: idSelected,
                    onSelect: (idSelected) {
                      setState(() {
                        this.idSelected = idSelected;
                      });
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8.0, 16.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Mi menú',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                if (productosFiltered != null && !loading && idSelected != null)
                  ...mapProducts(
                    productosFiltered
                        .where((prod) =>
                            prod.categories
                                .indexWhere((cat) => cat.id == idSelected) !=
                            -1)
                        .toList(),
                    productosCart,
                  )
                else if (productosFiltered != null &&
                    !loading &&
                    idSelected == null)
                  ...mapProducts(
                    productosFiltered,
                    productosCart,
                  )
                else
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ))
              ]),
            )
          ],
        ));
  }

  List<Widget> mapProducts(
      List<Producto> productos, List<Producto> productosCart) {
    List<Widget> retVal = new List<Widget>();

    // retVal.add(Padding(padding: const EdgeInsets.all(20.0)));

    retVal.addAll(productos.map((producto) {
      var indexProducto = productosCart
          .indexWhere((productoItem) => productoItem.id == producto.id);

      int cantidad = 0;

      if (indexProducto != -1) {
        cantidad = productosCart[indexProducto].quantity;
      } else {
        if (producto.type == 'variable') {
          var filt = productosCart
              .where((prodCart) =>
                  producto.variaciones
                      .indexWhere((_var) => _var.id == prodCart.id) !=
                  -1)
              .toList();

          int sum = 0;

          filt.forEach((prod) {
            sum += prod.quantity;
          });

          cantidad = sum;
        }
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductoCard(
          featured: producto.featured,
          loading: producto.loading,
          type: producto.type,
          nombre: producto.name,
          stockStatus: producto.stock_status,
          foto: producto.images.length > 0
              ? producto.images[0].src
              : 'https://tienda.ecodelivery.org/wp-content/uploads/2020/05/comida-pp.png',
          precio: producto.price,
          variaciones: producto.variaciones,
          onDetail: () => onDetail(producto, indexProducto, productosCart),
          onChangeStatus: (value) =>
              setStockStatus(producto.id, value ? 'instock' : 'outofstock'),
          onFeature: (value) => setFeatured(producto.id, value),
        ),
      );
    }).toList());

    // retVal.add(Padding(padding: const EdgeInsets.all(30.0)));

    return retVal;
  }

  onDetail(producto, indexProducto, productosCart) async {
    Provider.of<ProductoDetalleProvider>(context, listen: false)
        .setProductoDetalle(producto);
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new ProductDetailsPage(),
            fullscreenDialog: true));
  }

  addProduct(producto, indexProducto, List<Producto> productosCart) async {
    if (indexProducto != -1) {
      var productoFound = productosCart[indexProducto];

      if (productoFound.type == 'variable') {
        Provider.of<ProductoDetalleProvider>(context, listen: false)
            .setProductoDetalle(producto);

        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new ProductDetailsPage(),
                fullscreenDialog: true));
      } else {
        productoFound.quantity++;
        productosCart[indexProducto] = productoFound;
        setState(() {
          Provider.of<CartProvider>(context, listen: false).setProductos([
            ...productosCart,
          ].toList());
        });
      }
    } else {
      Producto nuevoProducto = producto;
      if (nuevoProducto.type == 'variable') {
        Provider.of<ProductoDetalleProvider>(context, listen: false)
            .setProductoDetalle(producto);
        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new ProductDetailsPage(),
                fullscreenDialog: true));
      } else {
        setState(() {
          nuevoProducto.quantity = 1;
          productosCart.add(nuevoProducto);
          Provider.of<CartProvider>(context, listen: false)
              .setProductos([...productosCart].toList());
        });
      }
    }
  }

  removeProduct(indexProducto, List<Producto> productosCart) {
    if (indexProducto == -1) return;

    var nuevoProducto = productosCart[indexProducto];
    var nuevaLista = [...productosCart];

    nuevoProducto.quantity--;

    if (nuevoProducto.quantity <= 0) {
      nuevaLista.removeAt(indexProducto);
    } else {
      nuevaLista[indexProducto] = nuevoProducto;
    }

    setState(() {
      Provider.of<CartProvider>(context, listen: false)
          .setProductos(nuevaLista);
    });
  }
}
