import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:snap_loop/core/secrets/secrets.dart';
import 'package:snap_loop/config/firebase_options.dart';

import 'package:snap_loop/my_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supaProjectUrl, anonKey: supaProjectApi);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
