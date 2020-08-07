class Comercio {
  final int idComercio;
  final int idCategoria;
  final String nombre;
  final String descripcion;
  final String urlWoo;
  final String slug;
  final String correo;
  final String portada;
  final num distancia;
  final String direccion;
  final double lat;
  final double lng;
  final DateTime feCreacion;
  final int usCreacion;
  final DateTime feModificacion;
  final int usModificacion;

  final int isOpen;
  final int highRequested;

  Comercio({
    this.idComercio,
    this.idCategoria,
    this.nombre,
    this.descripcion,
    this.urlWoo,
    this.slug,
    this.correo,
    this.portada,
    this.distancia,
    this.direccion,
    this.lat,
    this.lng,
    this.isOpen,
    this.highRequested,
    this.feCreacion,
    this.usCreacion,
    this.feModificacion,
    this.usModificacion,
  });

  factory Comercio.fromJson(Map<String, dynamic> json) {
    return Comercio(
      idComercio: json['idComercio'],
      idCategoria: json['idCategoria'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      urlWoo: json['urlWoo'],
      slug: json['slug'],
      correo: json['correo'],
      portada: json['portada'],
      direccion: json['direccion'] == null ? '-' : json['direccion'],
      lat: json['lat'],
      lng: json['lng'],
      isOpen: json['isOpen'],
      highRequested: json['highRequested'],
      usCreacion: json['usCreacion'],
      feCreacion: DateTime.parse(json['feCreacion']),
      usModificacion: json['usModificacion'],
      feModificacion: DateTime.parse(json['feModificacion']),
    );
  }
}
