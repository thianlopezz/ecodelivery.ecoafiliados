// Flutter
import 'package:ecodelivery/components/Input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/theme.dart' as THEME;

class InputDate extends StatelessWidget {
  static DateTime now = DateTime.now();

  DateTime selectedDate = DateTime(
    now.year - 18,
    DateTime.now().month,
    DateTime.now().day,
  );

  // var feNacimientoController = new TextEditingController(
  //     text: DateFormat('dd/MM/yyyy').format(selectedDate));

  final label;
  final inputTextValue;
  final controller;
  final validator;
  final hintText;
  final color;
  final textColor;
  final enabled;
  final Function onChange;
  final BuildContext context;

  InputDate(
      {@required this.label,
      @required this.inputTextValue,
      @required this.controller,
      this.selectedDate,
      this.hintText = '',
      this.validator,
      this.color = 'black',
      this.textColor = 'black',
      this.enabled = true,
      @required this.onChange,
      @required this.context});

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now());

    if (picked != null && picked != selectedDate) {
      onChange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Input(
              enabled: false,
              label: label,
              controller: TextEditingController(
                text: inputTextValue,
              ),
              validator: validator),

          // TextFormField(
          //   enabled: false,
          //   style: new TextStyle(color: Colors.white),
          //   controller: controller,
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return 'Ingresa tu fecha de nacimiento';
          //     }
          //     return null;
          //   },
          //   decoration: InputDecoration(
          //       labelText: 'Fecha de nacimiento',
          //       labelStyle: TextStyle(
          //           fontFamily: 'ComicNeue',
          //           fontWeight: FontWeight.bold,
          //           color: THEME.greenThemeColor),
          //       focusedBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: THEME.greenThemeColor)),
          //       disabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white))),
          //   // obscureText: true,
          // ),
        ),
        Expanded(
          child: IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: THEME.greenThemeColor,
            ),
            onPressed: () => _selectDate(context),
          ),
        )
      ],
    );
  }
}

// (value) {
//         if (value.isEmpty) {
//           return 'Ingresa tu usuario o correo';
//         }
//         return null;
//       }
