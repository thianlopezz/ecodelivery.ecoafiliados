import 'package:ecodelivery/models/Categoria.dart';
import 'package:ecodelivery/models/Comercio.dart';
import 'package:ecodelivery/models/Imagen.dart';
import 'package:intl/intl.dart';

class Producto {
  final int id;
  final String type;
  final String sku;
  final String name;
  final String description;
  final String short_description;
  final int stock_quantity;
  String stock_status;
  final String price;
  final String regular_price;
  final String sale_price;
  bool featured;
  final String weight;
  final DateTime date_created;
  final DateTime date_modified;

  final List<Categoria> categories;
  final List<Imagen> images;
  final List<Producto> variaciones;

  int quantity = 0;

  final bool isVariation;
  final String variation;

  bool loading;

  Producto(
      {this.id,
      this.type,
      this.sku,
      this.name,
      this.description,
      this.short_description,
      this.stock_quantity,
      this.stock_status,
      this.price,
      this.regular_price,
      this.sale_price,
      this.featured,
      this.weight,
      this.date_created,
      this.date_modified,
      this.categories,
      this.images,
      this.variaciones,
      this.isVariation = false,
      this.variation,
      this.quantity = 0,
      this.loading = false}) {}

  factory Producto.fromJson(Map<String, dynamic> json) {
    json['isVariation'] = false;

    var categorias = json['categories'] != null
        ? (json['categories'] as List)
            .map((i) => Categoria.fromJson(i))
            .toList()
        : new List<Categoria>();
    var imagenes = json['images'] != null
        ? (json['images'] as List).map((i) => Imagen.fromJson(i)).toList()
        : new List<Imagen>();

    List<Producto> variaciones = [];
    if (json['type'] == 'variable') {
      var variacion = (json['attributes'] as List)[0];
      // var opciones = (variacion['options'] as List);

      if (json['variaciones'] != null) {
        json['variation'] = variacion['name'];

        var _variaciones = (json['variaciones'] as List);
        variaciones = _variaciones.asMap().entries.map((entry) {
          _variaciones[entry.key]['name'] =
              '${(_variaciones[entry.key]['attributes'] as List)[0]['option']}';
          _variaciones[entry.key]['images'] = json['images'];
          _variaciones[entry.key]['description'] =
              '${json['name']} - ${(_variaciones[entry.key]['attributes'] as List)[0]['option']}';
          _variaciones[entry.key]['isVariation'] = true;
          return Producto.fromJson(_variaciones[entry.key]);
        }).toList();
      }

      json['price'] = setPrecio(json['type'], json['price'], variaciones);
    }

    return Producto(
        id: json['id'],
        type: json['type'],
        sku: json['sku'],
        name: json['name'],
        description: json['description'] == null
            ? ''
            : ('' + json['description'])
                .replaceAll('<p>', '')
                .replaceAll('</p>', ''),
        short_description: json['short_description'],
        stock_quantity: json['stock_quantity'],
        stock_status: json['stock_status'],
        price: "${json['price']}",
        regular_price: "${json['regular_price']}",
        sale_price: "${json['sale_price']}",
        featured: json['featured'],
        weight: json['weight'],
        date_created: json['date_created'] != null
            ? DateTime.parse(json['date_created'])
            : null,
        date_modified: json['date_created'] != null
            ? DateTime.parse(json['date_modified'])
            : null,
        categories: categorias,
        images: imagenes,
        isVariation: json['isVariation'],
        variation: json['variation'],
        variaciones: variaciones,
        quantity: json['quantity'] != null ? json['quantity'] : 0);
  }

  Map<String, dynamic> toProductLineJson() => {
        'product_id': id,
        'image': images != null && images.length > 0 ? images[0].src : null,
        'quantity': quantity,
      };
}

String setPrecio(type, precio, variaciones) {
  if (type != 'variable') {
    return precio;
  } else if (variaciones == null || variaciones.length == 1) {
    return precio;
  }

  return '${variaciones[0].price} - ${variaciones[variaciones.length - 1].price}';
}
