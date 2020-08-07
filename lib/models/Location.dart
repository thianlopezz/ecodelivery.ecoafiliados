class Location {
  final int idUbicacion;
  final int idUsuario;
  final String nombre;
  final String referencia;
  final double latitud;
  final double longitud;
  final DateTime feCreacion;
  final DateTime feModificacion;
  final DateTime feUltimoUso;

  Location(
      {this.idUbicacion,
      this.idUsuario,
      this.nombre,
      this.referencia,
      this.latitud,
      this.longitud,
      this.feCreacion,
      this.feModificacion,
      this.feUltimoUso});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        idUbicacion: json['idUbicacion'],
        idUsuario: json['idUsuario'],
        nombre: json['nombre'],
        referencia: json['referencia'],
        latitud: json['latitud'],
        longitud: json['longitud'],
        feCreacion: json['feCreacion'] != null
            ? DateTime.parse(json['feCreacion'])
            : null,
        feModificacion: json['feModificacion'] != null
            ? DateTime.parse(json['feModificacion'])
            : null,
        feUltimoUso: json['feUltimoUso'] != null
            ? DateTime.parse(json['feUltimoUso'])
            : null);
  }

  Map<String, dynamic> toJson() => _itemToJson(this);

  Map<String, dynamic> _itemToJson(Location instance) {
    return <String, dynamic>{
      'idUbicacion': instance.idUbicacion,
      'idUsuario': instance.idUsuario,
      'nombre': instance.nombre,
      'referencia': instance.referencia,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
    };
  }
}
