import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getAllPost();
  }

  void getAllPost() {
    context.read<PostBloc>().add(GetAllPostsEvent());
  }

  void deletePost() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailureState) {
                customSnackBar(
                  context,
                  "Failed to log out",
                  Colors.white,
                  Colors.red,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return Center(child: CircularProgressIndicator());
              } else {
                return IconButton(
                  onPressed: () async {
                    try {
                      context.read<AuthBloc>().add(SignOutEvent());
                    } catch (e) {
                      log("Failed logout");
                    }
                  },
                  icon: Icon(Icons.logout_outlined),
                );
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PostLoadingState || state is PostLoadingSuccessState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoadedState) {
            return ListView.builder(
              itemCount: state.post.length,
              itemBuilder: (context, index) {
                if (state.post.isEmpty) {
                  return Center(child: Text("No post available"));
                }
                return Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    children: [
                      Image.asset(state.post[index].imageUrl),
                      Text(state.post[index].caption),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), Text("Error")],
              ),
            );
          }
        },
      ),
    );
  }
}
