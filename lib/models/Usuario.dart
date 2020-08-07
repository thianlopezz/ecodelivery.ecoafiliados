class Usuario {
  final int idUsuario;
  final int idComercio;
  final String username;
  final String correo;
  final String contacto;
  final String isoCode;
  final String dialCode;
  final String contrasena;
  final String nombre;
  final String apellido;
  final String bio;
  final String token;
  final String foto;
  final String about;
  final DateTime feNacimiento;
  final String genero;
  final String socialProviderId;
  final String uid;
  final String displayName;
  final String comercio;
  final DateTime feCreacion;
  final DateTime feModificacion;
  final DateTime feUpdatePassword;

  Usuario(
      {this.idUsuario,
      this.idComercio,
      this.username,
      this.correo,
      this.contacto,
      this.isoCode,
      this.dialCode,
      this.contrasena,
      this.nombre,
      this.apellido,
      this.bio,
      this.token,
      this.foto,
      this.about,
      this.feNacimiento,
      this.genero,
      this.socialProviderId,
      this.uid,
      this.displayName,
      this.comercio,
      this.feCreacion,
      this.feModificacion,
      this.feUpdatePassword});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      idComercio: json['idComercio'],
      username: json['username'],
      correo: json['correo'],
      contacto: json['contacto'],
      isoCode: json['isoCode'],
      dialCode: json['dialCode'],
      contrasena: json['contrasena'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      bio: json['about'],
      token: json['token'],
      foto: json['foto'],
      about: json['about'],
      feNacimiento: json['feNacimiento'] != null
          ? DateTime.parse(json['feNacimiento'])
          : null,
      genero: json['genero'],
      socialProviderId: json['socialProviderId'],
      uid: json['uid'],
      displayName: json['displayName'],
      comercio: json['comercio'],
      feCreacion: json['feCreacion'] != null
          ? DateTime.parse(json['feCreacion'])
          : null,
      feModificacion: json['feModificacion'] != null
          ? DateTime.parse(json['feModificacion'])
          : null,
      feUpdatePassword: json['feUpdatePassword'] != null
          ? DateTime.parse(json['feUpdatePassword'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario.toString(),
      'username': username,
      'correo': correo,
      'contacto': contacto,
      'contrasena': contrasena,
      'contrasena1': contrasena,
      'nombre': nombre,
      'apellido': apellido,
      'bio': bio,
      'token': token,
      'foto': foto,
      'about': about,
      'feNacimiento': feNacimiento,
      'genero': genero,
      'socialProviderId': socialProviderId,
      'uid': uid,
      'displayName': displayName,
      'feCreacion': feCreacion,
      'feModificacion': feModificacion,
      'feUpdatePassword': feUpdatePassword,
    };
  }
}
