// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class Select extends StatelessWidget {
  Select(
      {this.value,
      this.label = '',
      this.hint = '',
      this.onChange,
      @required this.options,
      this.helperText,
      this.hasError = false});

  final value;
  final label;
  final hint;
  final List options;
  final onChange;
  final helperText;
  final hasError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(color: THEME.greenThemeColor),
          ),
          DropdownButton<String>(
            value: value,
            hint: hint != null ? Text(hint) : null,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            // style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: THEME.greenThemeColor,
            ),
            onChanged: onChange,
            isExpanded: true,
            items: options,
          ),
          if (helperText != null)
            Text(
              helperText,
              style: hasError ? new TextStyle(color: Colors.redAccent) : null,
            )
        ],
      ),
    );
  }
}

// (value) {
//         if (value.isEmpty) {
//           return 'Ingresa tu usuario o correo';
//         }
//         return null;
//       }
