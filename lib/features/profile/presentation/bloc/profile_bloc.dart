import 'dart:developer';
import 'dart:io';
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
          emit(UserProfileUserDetailsLoadedState(user, posts));
        } else {
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
        String? userProileUploadedImageUrl;
        log(event.userProfilePicUrl.toString());
        if(event.userProfilePicUrl.toString().startsWith("/")){
             userProileUploadedImageUrl = await supabaseStoragehelper
            .upLoadImageToSupaStore(File(event.userProfilePicUrl!), "profilePics");
        }
      

        event.userProfilePicUrl == ""
            ? await userprofileRepo.updateUserProfile(
              event.userId,
              event.userName,
              event.userBio,
              userProileUploadedImageUrl ?? event.userProfilePicUrl!,
            )
            : await userprofileRepo.updateUserProfile(
              event.userId,
              event.userName,
              event.userBio,
              userProileUploadedImageUrl ?? '',
            );
        final UserProfileEntity? updatedUser = await userprofileRepo
            .getuserProfile(event.userId);
        final posts = await postRepo.getPostsByUserId(event.userId);
        return emit(UserProfileUserDetailsLoadedState(updatedUser, posts));
      } catch (e) {
        return emit(UserProfileUserDetailsFailedState(e.toString()));
      }
    });

    on<FollowUnFollowButtonClickedEvent>((event, emit) async {
      try {
        await userprofileRepo.followUnFollowToggle(
          event.currentUserId,
          event.toggleUserId,
        );

        final updatedUser = await userprofileRepo.getuserProfile(
          event.toggleUserId,
        );

        final updatedPosts = await postRepo.getPostsByUserId(
          event.toggleUserId,
        );

        if (updatedUser != null) {
     
          emit(UserProfileUserDetailsLoadedState(updatedUser, updatedPosts));
        } else {
          emit(UserProfileUserDetailsFailedState("Failed to fecth data"));
        }
      } catch (e) {
        emit(UserProfileUserDetailsFailedState(e.toString()));
      }
    });
  }
}
