import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Center(child: Text("Home page")),
    );
  }
}
