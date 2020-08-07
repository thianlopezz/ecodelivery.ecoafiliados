import 'package:ecodelivery/models/Producto.dart';
import 'package:ecodelivery/providers/cart.dart';
import 'package:ecodelivery/providers/productoDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class ProductDetailsPage extends StatefulWidget {
  // ProductDetailsPage(BuildContext context) {}

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int cantidad = 1;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Producto producto =
    //       Provider.of<ProductoDetalleProvider>(context, listen: false).producto;

    //   List<Producto> productos =
    //       Provider.of<CartProvider>(context, listen: false).productos;

    //   Producto productFound =
    //       productos.firstWhere((item) => item.id == producto.id);

    //   setState(() {
    //     if (productFound != null) {
    //       cantidad = productFound.quantity;
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Producto producto =
        Provider.of<ProductoDetalleProvider>(context, listen: false).producto;

    return new Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Stack(
            children: <Widget>[
              Image(
                width: double.infinity,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
                image: NetworkImage(producto.images.length > 0
                    ? producto.images[0].src
                    : 'http://18.223.110.42/wp-content/uploads/2020/05/comida-pp.png'),
              ),
              Positioned(
                top: 48.0,
                left: 16.0,
                // padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 27.0,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text(
                  producto.name,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Precio ',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: THEME.blackThemeColor),
                      ),
                      TextSpan(
                        text: "\$${producto.price}",
                        style: TextStyle(
                            color: THEME.greenThemeColor,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                '${producto.quantity} x',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                          '\$${num.parse(producto.price) * producto.quantity}',
                          style: TextStyle(
                              color: THEME.blackThemeColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              if (producto.description != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Text(
                    'Detalles del producto',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
              if (producto.description != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Text(
                    producto.description,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    ));
  }
}
