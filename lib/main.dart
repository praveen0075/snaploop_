import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/themes/light_theme.dart';
import 'package:snap_loop/features/auth/data/auth_repository.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/pages/auth.dart';
import 'package:snap_loop/features/navigation/bloc/nav_bloc.dart';
import 'package:snap_loop/features/navigation/root_page.dart';
import 'package:snap_loop/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepository = AuthRespositoryFirebase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authrepository: authRepository),
          ),
          BlocProvider<NavBloc>(create: (context) => NavBloc()),
        ],
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:
              (context, snapshot) => snapshot.hasData ? RootPage() : Auth(),
        ),
      ),
    );
  }
}
