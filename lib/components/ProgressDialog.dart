import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../constants/theme.dart' as THEME;

createWhiteProgressDialog(context) {
  var pr = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

  // pr.style(
  //     progressWidget: CircularProgressIndicator(
  //   valueColor: AlwaysStoppedAnimation<Color>(THEME.greenThemeColor),
  // ));
  pr.style(
      progressWidget: Image.asset(
    "assets/logo_gif.gif",
    // height: 125.0,
    width: double.infinity,
  ));

  return pr;
}

createBlackProgressDialog(context) {
  var pr = createWhiteProgressDialog(context);

  pr.style(
      backgroundColor: THEME.blackThemeColor,
      messageTextStyle: TextStyle(color: Colors.white));
  return pr;
}
