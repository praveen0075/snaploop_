import 'package:flutter/material.dart';

Future<dynamic> customAlertBox({
  void Function()? onPressed,
  required BuildContext context,
  required String actionButtonText,
}) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: Text( 
            "Are you sure about this?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),

            TextButton(
              onPressed: onPressed,
              child: Text(actionButtonText, style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}
