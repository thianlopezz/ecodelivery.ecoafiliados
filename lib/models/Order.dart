import 'package:ecodelivery/models/Invoice.dart';
import 'package:ecodelivery/models/Location.dart';
import 'package:ecodelivery/models/Producto.dart';

class Order {
  final int idOrden;
  final int idUsuario;
  final int idWoo;
  final int idDatosFacturacion;
  final int idUbicacion;
  final int idComercio;
  final String comercio;
  final String notas;
  final String portadaComercio;
  final String totalOrden;
  final String valorEnvio;
  final String total;
  final int cantidadItems;
  String estado;
  final String status;
  final String tipoEntrega;
  final DateTime fechaPedido;
  final DateTime feCreacion;
  final DateTime feModificacion;

  final List<Producto> productos;

  final Location location;
  final Invoice invoice;

  final String nombre;

  Order(
      {this.idOrden,
      this.idUsuario,
      this.idWoo,
      this.idDatosFacturacion,
      this.idUbicacion,
      this.idComercio,
      this.comercio,
      this.notas,
      this.portadaComercio,
      this.totalOrden,
      this.valorEnvio,
      this.total,
      this.cantidadItems,
      this.estado,
      this.status,
      this.tipoEntrega,
      this.fechaPedido,
      this.feCreacion,
      this.feModificacion,
      this.productos,
      this.location,
      this.invoice,
      this.nombre});

  factory Order.fromJson(Map<String, dynamic> json) {
    List<Producto> productos = (json['productos'] as List)
        .map((producto) => Producto.fromJson(producto))
        .toList();

    Location location = Location.fromJson(json['location']);
    Invoice invoice = Invoice.fromJson(json['invoice']);

    return Order(
        idOrden: json['idOrden'],
        idUsuario: json['idUsuario'],
        idWoo: json['idWoo'],
        idDatosFacturacion: json['idDatosFacturacion'],
        idUbicacion: json['idUbicacion'],
        idComercio: json['idComercio'],
        comercio: json['comercio'],
        notas: json['notas'] == null ? '' : json['notas'],
        portadaComercio: json['portadaComercio'],
        totalOrden: "${json['totalOrden']}",
        valorEnvio: "${json['valorEnvio']}",
        total: "${json['total']}",
        cantidadItems: json['cantidadItems'],
        estado: json['estado'],
        status: json['status'],
        tipoEntrega: json['tipoEntrega'],
        productos: productos,
        fechaPedido: json['fechaPedido'] != null
            ? DateTime.parse(json['fechaPedido'])
            : null,
        feCreacion: json['date_created'] != null
            ? DateTime.parse(json['date_created'])
            : null,
        feModificacion: json['date_modified'] != null
            ? DateTime.parse(json['date_modified'])
            : null,
        location: location,
        invoice: invoice,
        nombre: json['nombre']);
  }
}
