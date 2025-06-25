import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/helpers/supabase_storagehelper.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/post/domain/repositories/post_repository.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/domain/repositories/userprofile_repo.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvents, ProfileState> {
  final AuthRepo authRepo;
  final UserprofileRepo userprofileRepo;
  final SupabaseStoragehelper supabaseStoragehelper;
  final PostRepository postRepo;
  //  UserEntity? currentUser;
  ProfileBloc({
    required this.authRepo,
    required this.userprofileRepo,
    required this.supabaseStoragehelper,
    required this.postRepo,
  }) : super(IntialProfileState()) {
    on<GetCurrentLoggedInUserEvent>((event, emit) async {
      emit(UserProfileUserDetailsLoadingState());
      try {
        final UserEntity? userEntity = await authRepo.getCurrentUser();
        if (userEntity != null) {
          final UserProfileEntity? user = await userprofileRepo.getuserProfile(
            userEntity.userid,
          );
          final posts = await postRepo.getPostsByUserId(userEntity.userid);
          log("profile bloc getcurrentloggedevent user entity: $user");
          emit(UserProfileUserDetailsLoadedState(user, posts));
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

    on<FetchCurrentUserDetailsEvent>((event, emit) async {
      emit(UserProfileUserDetailsLoadingState());
      try {
        final user = await userprofileRepo.getuserProfile(event.userId);
        final posts = await postRepo.getPostsByUserId(event.userId);
        if (user != null) {
          emit(UserProfileUserDetailsLoadedState(user, posts));
        } else {
          emit(UserProfileUserDetailsFailedState("Unable to load the user"));
        }
      } catch (e) {
        emit(UserProfileUserDetailsFailedState(e.toString()));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(UserProfileUserDetailsLoadingState());
      try {
        final userProileUploadedImageUrl = await supabaseStoragehelper
            .upLoadImageToSupaStore(event.userProfilePicUrl, "profilePics");

        log("userprofile pic URL is -> $userProileUploadedImageUrl");
        event.userProfilePicUrl.path == ""
            ? await userprofileRepo.updateUserProfile(
              event.userId,
              event.userName,
              event.userBio,
              userProileUploadedImageUrl ?? event.userProfilePicUrl.path,
            )
            : await userprofileRepo.updateUserProfile(
              event.userId,
              event.userName,
              event.userBio,
              userProileUploadedImageUrl ?? '',
            );
        log("User event id : ${event.userId}");
        final UserProfileEntity? updatedUser = await userprofileRepo
            .getuserProfile(event.userId);
        final posts = await postRepo.getPostsByUserId(event.userId);
        return emit(UserProfileUserDetailsLoadedState(updatedUser, posts));
      } catch (e) {
        return emit(UserProfileUserDetailsFailedState(e.toString()));
      }
    });
  }
}
