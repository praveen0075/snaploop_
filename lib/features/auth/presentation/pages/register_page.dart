import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_passtextfield.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/core/constants/kcolors.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart'
    show kh10, kh20, kh30;
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';
import 'package:snap_loop/core/components/custom_button.dart';
import 'package:snap_loop/core/components/custom_textformfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.ontap});
  final void Function()? ontap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conformPassController = TextEditingController();

 final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void register() async {
    final isValidate = _formkey.currentState!.validate();
    if (isValidate) {
      UserEntity user = UserEntity(
        userid: DateTime.timestamp().millisecondsSinceEpoch.toString(),
        userName: userNameController.text,
        userEmail: emailController.text,
      );
      if (passController.text == conformPassController.text) {
        try {
          context.read<AuthBloc>().add(
            RegisterEvent(user, conformPassController.text),
          );
        } catch (e) {
          log("error : ${e.toString()}");
          customSnackBar(context, e.toString(), Colors.white, Colors.red);
        }
      } else {
        customSnackBar(
          context,
          "Password doesn't match",
          Colors.white,
          Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: kGradientClrList,
          ), 
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  return state is AuthLoadingState
                      ? Center(child: CircularProgressIndicator())
                      : Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Text(
                              "Create an account",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              "Welcome to SnapLoop",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            kh20,
                            registerCard(context),
                          ],
                        ),
                      );
                },
                listener: (context, state) {
                  if (state is AuthFailureState) {
                    customSnackBar(
                      context,
                      state.errormsg!,
                      Colors.white,
                      Colors.red,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card registerCard(BuildContext context) {
    return Card(
      color: Colors.white,
      
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign Up!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // kh20,
            kh10,
            CustomeTextformfield(
              txtController: userNameController,
              hintText: "Name",
              prefixIcon: Icons.person_outline,
              filledColor: Color.fromARGB(81, 206, 216, 255),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your name";
                } else {
                  return null;
                }
              },

            ),
            kh20,
            CustomeTextformfield(
              txtController: emailController,
              filledColor: Color.fromARGB(81, 206, 216, 255),
              hintText: "Email",
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the Email id";
                } else {
                  return null;
                }
              },
            ),
            kh20,
            CustomPasstextfield(
              txtController: passController,
              filledColor: Color.fromARGB(81, 206, 216, 255),
              hintText: "Password",
              prefixIcon: Icons.lock_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter a password";
                } else {
                  return null;
                }
              },
            ),
            kh20,
            CustomPasstextfield(
              txtController: conformPassController,
              filledColor: Color.fromARGB(81, 206, 216, 255),
              hintText: "Confirm Password",
             prefixIcon: Icons.lock_person_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter confirmation password";
                } else {
                  return null;
                }
              },
              // suffixIcon: Icons.visibility,
            ),
            kh20,
            CustomButton( 
              buttonText: "Sign up",
              buttonColor: Theme.of(context).colorScheme.primary,
              buttonTextColor: Colors.white,
              onTap: register,
            ),
            kh30,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? "),
                GestureDetector(
                  onTap: widget.ontap,
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
