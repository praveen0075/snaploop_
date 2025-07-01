import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_alertbox.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.check_box_outlined),
            title: Text("Terms & Conditions"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            leading: Icon(Icons.share_outlined),
            title: Text("Share the application"),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
          ListTile(
            onTap: () {
              try {
                customAlertBox(
                  context: context,
                  actionButtonText: "Sign out",
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                );
              } catch (e) {
                log("$e");
              }
            },
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("sign out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
