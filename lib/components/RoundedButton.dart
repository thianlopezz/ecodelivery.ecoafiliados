// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart' as THEME;

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {@required this.text,
      @required this.onPress,
      this.bgColor = THEME.greenThemeColor,
      this.textColor = Colors.white});

  final text;
  final Function onPress;
  final bgColor;
  final textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        height: 40.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.greenAccent,
          color: THEME.greenThemeColor,
          elevation: 7.0,
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ComicNeue'),
            ),
          ),
        ),
      ),
    );
  }
}
