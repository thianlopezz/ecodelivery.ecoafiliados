class Invoice {
  final int idDatosFacturacion;
  int idUsuario;
  final String nombre;
  final String identificacion;
  final String correo;
  final String telefono;
  final String direccion;
  final DateTime feCreacion;
  final DateTime feModificacion;
  final DateTime feUltimoUso;

  Invoice(
      {this.idDatosFacturacion,
      this.idUsuario,
      this.nombre,
      this.identificacion,
      this.correo,
      this.telefono,
      this.direccion,
      this.feCreacion,
      this.feModificacion,
      this.feUltimoUso});

  // setidUsuario(int idUsuario) {
  //   this.idUsuario = idUsuario;
  // }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        idDatosFacturacion: json['idDatosFacturacion'],
        idUsuario: json['idUsuario'],
        nombre: json['nombre'],
        identificacion: json['identificacion'],
        correo: json['correo'],
        telefono: json['telefono'],
        direccion: json['direccion'],
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

  Map<String, dynamic> _itemToJson(Invoice instance) {
    return <String, dynamic>{
      'idDatosFacturacion': instance.idDatosFacturacion,
      'idUsuario': instance.idUsuario,
      'nombre': instance.nombre,
      'identificacion': instance.identificacion,
      'correo': instance.correo,
      'telefono': instance.telefono,
      'direccion': instance.direccion,
    };
  }
}
