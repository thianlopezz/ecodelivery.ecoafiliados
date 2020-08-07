class Categoria {
  final int id;
  final String name;
  final int parent;
  final String parentName;
  final String description;
  final String image;
  final String path;
  final String type;
  final String color;

  Categoria({
    this.id,
    this.name,
    this.parent,
    this.parentName,
    this.description,
    this.image,
    this.path,
    this.type = 'woo',
    this.color,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
        id: json['id'],
        name: json['name'],
        parent: json['parent'],
        parentName: json['parentName'] == null ? '' : json['parentName'],
        description: json['description'],
        image: json['image'] == null
            ? 'https://tienda.ecodelivery.org/wp-content/uploads/2020/05/comida-pp.png'
            : json['image']['src']);
  }

  factory Categoria.fromEcoJson(Map<String, dynamic> json) {
    return Categoria(
        id: json['idCategoria'],
        name: json['categoria'],
        description: json['descripcion'],
        image: json['image'],
        path: json['path'],
        type: 'eco',
        color: json['hexColor']);
  }
}
