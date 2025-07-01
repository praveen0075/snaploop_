import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/helpers/supabase_storagehelper.dart';
import 'package:snap_loop/core/secrets/secrets.dart';
import 'package:snap_loop/core/themes/dark_theme.dart';
import 'package:snap_loop/core/themes/light_theme.dart';
import 'package:snap_loop/features/auth/data/auth_repository.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/pages/auth.dart';
import 'package:snap_loop/features/navigation/bloc/nav_bloc.dart';
import 'package:snap_loop/features/navigation/root_page.dart';
import 'package:snap_loop/config/firebase_options.dart';
import 'package:snap_loop/features/post/data/firebase_post_repo.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/profile/data/firebase_userprofile_repo.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/search/data/search_fire_repo.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supaProjectUrl, anonKey: supaProjectApi);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepository = AuthRespositoryFirebase();
  final userRepository = FirebaseUserProfileRepo();
  final postRepository = FirebasePostRepo();
  final supBaseStorage = SupabaseStoragehelper();
  final searchRepo = SearchFireRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authrepository: authRepository),
          ),
          BlocProvider<NavBloc>(create: (context) => NavBloc()),
          BlocProvider<ProfileBloc>(
            create:
                (context) => ProfileBloc(
                  authRepo: authRepository,
                  userprofileRepo: userRepository,
                  supabaseStoragehelper: supBaseStorage,
                  postRepo: postRepository,
                ),
          ),
          BlocProvider<PostBloc>(
            create:
                (context) => PostBloc(
                  authRepo: authRepository,
                  postRepo: postRepository,
                  userprofileRepo: userRepository,
                  supabaseStoragehelper: supBaseStorage,
                ),
          ),
          BlocProvider<SearchBloc>(
            create:
                (context) => SearchBloc(
                  searchRepo: searchRepo,
                  authRepo: authRepository,
                  userprofileRepo: userRepository,
                ),
          ),
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
