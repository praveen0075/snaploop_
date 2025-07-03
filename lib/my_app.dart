
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/helpers/supabase_storagehelper.dart';
import 'package:snap_loop/core/themes/dark_theme.dart';
import 'package:snap_loop/core/themes/light_theme.dart';
import 'package:snap_loop/features/auth/data/auth_repository.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/pages/auth.dart';
import 'package:snap_loop/features/navigation/bloc/nav_bloc.dart';
import 'package:snap_loop/features/navigation/root_page.dart';
import 'package:snap_loop/features/post/data/firebase_post_repo.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/profile/data/firebase_userprofile_repo.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/search/data/search_fire_repo.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepository = AuthRespositoryFirebase();
  final userRepository = FirebaseUserProfileRepo();
  final postRepository = FirebasePostRepo();
  final supBaseStorage = SupabaseStoragehelper();
  final searchRepo = SearchFireRepo();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _isConnectedStream = StreamController<bool>();

  void _listenToConnectivity() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> resultList,
    ) {
      final isConnected = resultList.any((r) => r != ConnectivityResult.none);
      _isConnectedStream.add(isConnected);
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenToConnectivity(); 

    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
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
        child: StreamBuilder<bool>(
          stream: _isConnectedStream.stream,
          initialData: true,
          builder: (context, snapshot) {
            final isConnected = snapshot.data ?? true;

            if (!isConnected) {
              Future.delayed(Duration(seconds: 1), () {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(
                    content: Text('No Internet Connection',style: TextStyle(color: Colors.white),),
                    backgroundColor: Colors.red,
                  
                  ),
                );
              });
            }

            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                return snapshot.hasData ? RootPage() : Auth();
              },
            );
          },
        ),
      ),
    );
  }
}
