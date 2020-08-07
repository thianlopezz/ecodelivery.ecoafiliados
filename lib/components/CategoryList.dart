import 'package:ecodelivery/models/Categoria.dart';
import 'package:flutter/material.dart';
import 'package:ecodelivery/components/CategoryItem.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key key, this.categorias, this.idSelected, this.onSelect})
      : super(key: key);

  final List<Categoria> categorias;
  final int idSelected;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...this.categorias.map((cat) => CategoryItem(
                title: cat.name,
                isActive: cat.id == idSelected,
                press: () {
                  onSelect(cat.id);
                },
              ))
        ],
      ),
    );
  }
}
