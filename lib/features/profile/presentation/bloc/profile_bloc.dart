import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/domain/repositories/userprofile_repo.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  final AuthRepo authRepo;
  final UserprofileRepo userprofileRepo;
  //  UserEntity? currentUser;
  ProfileBloc({required this.authRepo, required this.userprofileRepo})
    : super(IntialProfileState()) {
    on<GetCurrentLoggedInUserEvent>((event, emit) async {
      emit(UserProfileUserDetailsLoadingState());
      try {
        final UserEntity? userEntity = await authRepo.getCurrentUser();
        if (userEntity != null) {
          final UserProfileEntity? user = await userprofileRepo.getuserProfile(
            userEntity.userid,
          );
          log("profile bloc getcurrentloggedevent user entity: $user");
          emit(UserProfileUserDetailsLoadedState(user));
        } else {
          log("null user :::");
          emit(
            UserProfileUserDetailsFailedState("Unable to find user details"),
          );
        }
      } catch (e) {
        log("exception profile bloc :-> ${e.toString()}");
        emit(UserProfileUserDetailsFailedState(e.toString()));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(UserProfileUserDetailsLoadingState());
      try {
        final UserProfileEntity? userprofile = await userprofileRepo
            .getuserProfile(event.userId);
        if (userprofile != null) {
          await userprofileRepo.updateUserProfile(event.userProfileEntiry);
          log("User event id : ${event.userId}");
          final UserProfileEntity? updatedUser = await userprofileRepo
              .getuserProfile(event.userId);
          return emit(UserProfileUserDetailsLoadedState(updatedUser));
        } else {
          log("Null updated user : profile bloc");
          emit(
            UserProfileUserDetailsFailedState(
              "Something went wrong on fetching userprofile",
            ),
          );
        }
      } catch (e) {
        return emit(UserProfileUserDetailsFailedState(e.toString()));
      }
    });
  }
}
