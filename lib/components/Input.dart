// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class Input extends StatelessWidget {
  Input(
      {@required this.label,
      this.controller,
      this.hintText = '',
      this.maxLines = 1,
      this.validator,
      this.color = 'black',
      this.textColor = 'black',
      this.enabled = true});

  final label;
  final controller;
  final validator;
  final hintText;
  final maxLines;
  final color;
  final textColor;
  final enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      style: new TextStyle(
          color: color == 'black' ? THEME.blackThemeColor : Colors.white),
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
              color: THEME.greenThemeColor),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: THEME.greenThemeColor)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: color == 'black'
                      ? THEME.blackThemeColor
                      : Colors.white))),
    );
  }
}

// (value) {
//         if (value.isEmpty) {
//           return 'Ingresa tu usuario o correo';
//         }
//         return null;
//       }
