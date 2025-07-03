import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appVersion = "";
  String appBilderNumber = "";

  Future<void> _getAppVersion() async {
    final appInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = appInfo.version;
      appBilderNumber = appInfo.buildNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "SnapLoop",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                kh20,
                Text(
                  "SnapLoop is a fun and social photo-sharing app where you can post, explore, and connect with others. Built with love using Flutter and Firebase.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                kh20,
                Text(
                  "Developer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text("Praveen C", style: TextStyle(color: Colors.grey)),
                kh10,
                Text(
                  "Contact",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap:
                      () =>
                          launchUrl(Uri.parse("mailto:snaploop478@gmail.com")),
                  child: Text(
                    "snaploop478@gmail.com",
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Version $appVersion (Build $appBilderNumber)",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
