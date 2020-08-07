// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class LabelTitle extends StatelessWidget {
  LabelTitle({@required this.title, this.subtitle, this.divider = false});

  final title;
  final subtitle;
  final divider;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              width: double.infinity,
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: title,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: THEME.blackThemeColor,
                        fontWeight: FontWeight.bold)),
                if (subtitle != null)
                  TextSpan(
                      text: subtitle,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))
              ])),
            ),
          ),
          if (divider)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Divider(color: Colors.black),
            ),
        ]);
  }
}
