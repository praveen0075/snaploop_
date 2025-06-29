// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:snap_loop/core/components/custom_snackbar.dart';
// import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
// import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
// import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';
// import 'package:snap_loop/features/home/presentation/pages/home_page.dart';

// class EmailVerifiyPage extends StatefulWidget {
//   const EmailVerifiyPage({
//     super.key,
//     required this.user,
//     required this.confrmPass,
//   });
//   final UserEntity user;
//   final String confrmPass;

//   @override
//   State<EmailVerifiyPage> createState() => _EmailVerifiyPageState();
// }

// class _EmailVerifiyPageState extends State<EmailVerifiyPage> {
//   @override
//   void initState() {
//     super.initState();
//     log("User entity (email verify page) --> ${widget.user}");
//     log("conform pass (email verify page) --> ${widget.confrmPass}");
//     context.read<AuthBloc>().add(RegisterEvent(widget.user, widget.confrmPass));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(Icons.email_outlined),
//             Text("Verify your email"),
//             Text(
//               "We have sent a verification link to your Email Id ${widget.user.userEmail}. Please verify it",
//               textAlign: TextAlign.center,
//             ),
//             BlocConsumer<AuthBloc, AuthState>(
//               builder: (context, state) {
//                 if (state is AuthLoadingState) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (state is AuthFailureState) {
//                   return ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text("Back to register"),
//                   );
//                 } else if (state is AuthUserLoggedIn) {
//                   return ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                         (route) => false,
//                       );
//                     },
//                     child: Text("Continue"),
//                   );
//                 } else {
//                   return ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text("Back to register"),
//                   );
//                 }
//               },
//               listener: (context, state) {
//                 if (state is AuthFailureState) {
//                   customSnackBar(
//                     context,
//                     state.errormsg.toString(),
//                     Colors.white,
//                     Colors.red,
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
