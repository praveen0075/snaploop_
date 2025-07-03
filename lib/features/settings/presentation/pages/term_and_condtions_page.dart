import 'package:flutter/material.dart';
import 'package:snap_loop/core/secrets/secrets.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: Text("Terms & Conditions")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            kTermsAndConditions,
            style: TextStyle(fontSize: 15, color: color),
          ),
        ),
      ),
    );
  }
}