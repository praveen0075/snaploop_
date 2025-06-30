 import 'package:flutter/material.dart';

Future<dynamic> deleteShowDialog({void Function()? onPressed,required BuildContext context}) {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            // title: Text("Delete?"),
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
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
