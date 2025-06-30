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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // login button clicked
  void login() {
    final isLoginValidate = _formKey.currentState!.validate();
    if (isLoginValidate) {
      final String email = emailController.text;
      final String password = passwordController.text;

      // bloc and sign in event triggered
      context.read<AuthBloc>().add(SignInEvent(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: kGradientClrList,
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
                      ? Center(child: CircularProgressIndicator())
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
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              "Sign in to continue",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.secondary,
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
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign In",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            kh10,
            //Textform field for email id
            CustomeTextformfield(
              hintText: "Email",
              txtController: emailController,
              prefixIcon: Icons.email_outlined,
              filledColor: kTextFieldFilledColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your Email Id";
                } else {
                  return null;
                }
              },
            ),
            kh20,

            //Textform field for password
            CustomPasstextfield(
              hintText: "Password",
              txtController: passwordController,
              prefixIcon: Icons.lock_outlined,
              filledColor: kTextFieldFilledColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the password";
                } else {
                  return null;
                }
              },
              // suffixIcon: Icons.visibi//lity,
            ),
            kh40,

            // login details submit button
            CustomButton(
              buttonText: "Login",
              onTap: login,
              buttonColor: Colors.deepPurple,
              buttonTextColor: Colors.white,
            ),
            kh30,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                // user don't have an account so go to the register page
                GestureDetector(
                  onTap: widget.ontap,
                  child: Text(
                    "Register",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
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
