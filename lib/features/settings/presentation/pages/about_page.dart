import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SnapLoop"),
            Text("Version", style: TextStyle(color: Colors.grey)),
            Text(
              "SnapLoop is a fun and social photo-sharing app where you can post, explore, and connect with others. Built with love using Flutter and Firebase.",
              style: TextStyle(fontSize: 16),
            ),
            Text("Developer",style: TextStyle(fontWeight: FontWeight.bold),),

            Text("Praveen C"),
          ],
        ),
      ),
    );
  }
}
