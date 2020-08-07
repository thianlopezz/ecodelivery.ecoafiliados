class Imagen {
  final int id;
  final String name;
  final String src;
  final String alt;
  final DateTime date_created;
  final DateTime date_modified;

  Imagen({
    this.id,
    this.name,
    this.src,
    this.alt,
    this.date_created,
    this.date_modified,
  });

  factory Imagen.fromJson(Map<String, dynamic> json) {
    return Imagen(
      id: json['id'],
      name: json['name'],
      src: json['src'],
      alt: json['alt'],
      date_created: json['date_created'] != null
          ? DateTime.parse(json['date_created'])
          : null,
      date_modified: json['date_modified'] != null
          ? DateTime.parse(json['date_modified'])
          : null,
    );
  }
}
