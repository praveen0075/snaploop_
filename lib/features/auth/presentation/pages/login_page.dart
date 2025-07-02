import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_passtextfield.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/core/constants/kcolors.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';
import 'package:snap_loop/core/components/custom_button.dart';
import 'package:snap_loop/core/components/custom_textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.ontap});

  final void Function()? ontap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Login logic
  void login() {
    final isLoginValidate = _formKey.currentState!.validate();
    if (isLoginValidate) {
      final String email = emailController.text;
      final String password = passwordController.text;

      context.read<AuthBloc>().add(SignInEvent(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter, 
            colors: [
              colorScheme.surface,
              colorScheme.surface.withAlpha(128), 
              colorScheme.primary.withAlpha(51), 
              colorScheme.primary,
              colorScheme.primary.withAlpha(128),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthUserLoggedIn) {
                    customSnackBar(
                      context,
                      "Logged in successfully",
                      Colors.white,
                      Colors.green,
                    );
                  } else if (state is AuthFailureState) {
                    customSnackBar(
                      context,
                      state.errormsg.toString(),
                      Colors.white,
                      Colors.red,
                    );
                  }
                },
                builder: (context, state) {
                  return state is AuthLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome Back !",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              "Sign in to continue",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: colorScheme.secondary,
                              ),
                            ),
                            kh60,
                            loginCard(context),
                          ],
                        ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card loginCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign In",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: colorScheme.primary,
              ),
            ),
            kh10,

            // Email
            CustomeTextformfield(
              maxLine: 1,
              hintText: "Email",
              txtController: emailController,
              prefixIcon: Icons.email_outlined,
              filledColor: kTextFieldFilledColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your Email Id";
                }
                return null;
              },
            ),
            kh20,

            // Password
            CustomPasstextfield(
              hintText: "Password",
              txtController: passwordController,
              prefixIcon: Icons.lock_outlined,
              filledColor: kTextFieldFilledColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the password";
                }
                return null;
              },
            ),
            kh40,

            // Login Button
            CustomButton(
              buttonText: "Sign In",
              onTap: login,
              buttonColor: colorScheme.primary,
              buttonTextColor: Colors.white,
            ),
            kh30,

            // Register Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(color: colorScheme.inversePrimary),
                ),
                GestureDetector(
                  onTap: widget.ontap,
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
