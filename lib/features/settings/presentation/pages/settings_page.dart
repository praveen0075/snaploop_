import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_alertbox.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/settings/presentation/pages/about_page.dart';
import 'package:snap_loop/features/settings/presentation/pages/term_and_condtions_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void alertBoxForShareApp() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Unavailable !"),
            content: Text(
              "Share is not available now, we will update it soon..",
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.inversePrimary),
      ),
      body: Column(
        children: [
          ListTile(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                ),
            leading: Icon(
              Icons.info_outline,
              color: colorScheme.inversePrimary,
            ),
            title: Text("About", style: textTheme.bodyLarge),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: colorScheme.inversePrimary,
            ),
          ),
          ListTile(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsPage(),
                  ),
                ),
            leading: Icon(
              Icons.check_box_outlined,
              color: colorScheme.inversePrimary,
            ),
            title: Text("Terms & Conditions", style: textTheme.bodyLarge),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: colorScheme.outline,
            ),
          ),
          ListTile(
            onTap: () => alertBoxForShareApp(),
            leading: Icon(
              Icons.share_outlined,
              color: colorScheme.inversePrimary,
            ),
            title: Text("Share the application", style: textTheme.bodyLarge),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: colorScheme.outline,
            ),
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
