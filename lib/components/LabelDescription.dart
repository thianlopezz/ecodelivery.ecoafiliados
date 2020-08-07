// Flutter
import 'package:ecodelivery/components/LabelTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/theme.dart' as THEME;

class LabelDescription extends StatelessWidget {
  LabelDescription({@required this.label, this.value, this.onPress});

  final label;
  final value;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LabelTitle(
            title: label,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              value != null ? value : '-',
              style: TextStyle(
                color: THEME.blackThemeColor,
                fontSize: 17.0,
              ),
            ),
          )
        ]);
  }
}
