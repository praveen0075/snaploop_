import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_event.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authrepository;
  // UserEntity? _currentUser;

  AuthBloc({required this.authrepository}) : super(AuthInitialState()) {
    // on<CheckAuthEvent>((event, emit) async {
    //   emit(AuthLoadingState());
    //   try {
    //     final UserEntity? user = await authrepository.getCurrentUser();
    //     if (user != null) {
    //       // _currentUser = user;
    //       emit(AuthUserLoggedIn(user));
    //     } else {
    //       emit(AuthUserLoggedOut());
    //     }
    //   } catch (e) {
    //     emit(AuthFailureState(e.toString()));
    //   }
    // });

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
        emit(AuthFailureState(e.toString()));
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
        log(e.toString());
        emit(AuthFailureState(e.toString()));
      }
    });

    // // check current user event
    // on<CheckCurrentUer>((event, emit) async{
    //   final user = await authrepository.getCurrentUser();
    //   if(user != null){

    //   }
    // },);

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
