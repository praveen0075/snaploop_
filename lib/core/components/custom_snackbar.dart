import 'package:flutter/material.dart';

void customSnackBar(
  BuildContext ctx,
  String txtContent,
  Color? txtColor,
  Color? backgroundColor,
) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
    behavior: SnackBarBehavior.floating,
      content: Text(
        txtContent,
        style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
    ),
  );
}
