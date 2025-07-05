import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/kstrings.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authrepository;
  // UserEntity? _currentUser;

  AuthBloc({required this.authrepository}) : super(AuthInitialState()) {
    // operations on Sign In event.
    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        // sign in user
        await authrepository.logInWithUserEmailAndPassword(
          event.userEmail,
          event.userPassword,
        );
        final user = await authrepository.getCurrentUser();
        if (user != null) {
          emit(AuthUserLoggedIn(user));
        } else {
          emit(AuthFailureState("Something went wrong #"));
        }
      } catch (e) {
        log(e.toString());
        String errorMsg;
        if (e.toString() ==
                "Exception: Failed to login: [firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired." ||
            e.toString() ==
                "Exception: Failed to login: [firebase_auth/invalid-email] The email address is badly formatted.") {
          errorMsg = "Invalid Email or Password";
        } else if (e.toString() ==
            "Exception: Failed to login: [firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
          errorMsg = kNoInternetErrorString;
        } else {
          errorMsg = e.toString();
        }
        emit(AuthFailureState(errorMsg));
      }
    });

    // operations on register event.
    on<RegisterEvent>((event, emit) async {
      
      emit(AuthLoadingState());
      try {
        // register new user
        await authrepository.registerNewUser(event.user, event.password);
        final user = await authrepository.getCurrentUser();
        if (user != null) {
          emit(AuthUserLoggedIn(user));
        } else {
          emit(AuthFailureState("Unauthorized user!!"));
        } 
      } catch (e) {
        String errormsg;
        if(e.toString() ==
            "Exception: Failed to login: [firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred."){
             errormsg = kNoInternetErrorString; 
            }else{
              errormsg = e.toString();
            }
        emit(AuthFailureState(errormsg.toString() ));
      }
    });

    // Sign out event
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        // sign out the user
        await authrepository.logOut();
        // user signed out success
        emit(AuthUserLoggedOut());
      } catch (e) {
        // user sisgned out failed
        emit(AuthFailureState(e.toString()));
      }
    });
  }
}
