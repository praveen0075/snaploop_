import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/helpers/supabase_storagehelper.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/domain/repositories/post_repository.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/domain/repositories/userprofile_repo.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepo;
  final AuthRepo authRepo;
  final UserprofileRepo userprofileRepo;
  final SupabaseStoragehelper supabaseStoragehelper;

  PostBloc({
    required this.postRepo,
    required this.authRepo,
    required this.userprofileRepo,
    required this.supabaseStoragehelper,
  }) : super(PostInitialState()) {
    on<GetCurrentUserEvent>((event, emit) async {
      emit(PostLoadingState());
      try {
        final user = await authRepo.getCurrentUser();
        final userProfile = await userprofileRepo.getuserProfile(user!.userid);
        log(userProfile!.userEmail);
        emit(GetCurrentUserSuccessState(userProfile));
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });

    on<CreatePostEvent>((event, emit) async {
      emit(PostLoadingState());
      try {
        final imageUrl = await supabaseStoragehelper.upLoadImageToSupaStore(
          event.postFile,
          "user-posts",
        );
        log("file image post uploaded to supabase");
        if (imageUrl != null) {
          final updatedPostEntity = event.postEntity.copyWith(
            imageUrl: imageUrl,
          );
          await postRepo.createPost(updatedPostEntity);
          emit(PostLoadingSuccessState());
        } else {
          emit(PostErrorState("Unable to upload the post"));
        }
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });

    on<DeletePostEvent>((event, emit) async {
      emit(PostLoadingState());
      try {
        await postRepo.deletePost(event.postId);
        emit(PostLoadingSuccessState());
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });

    on<GetAllPostsEvent>((event, emit) async {
      emit(PostUpLoadingState());
      try {
        final List<PostEntity> postList = await postRepo.getAllPosts();
        final UserEntity? currentUser = await authRepo.getCurrentUser();
        if (currentUser != null) {
          final UserProfileEntity? user = await userprofileRepo.getuserProfile(
            currentUser.userid,
          );
          emit(PostLoadedState(postList, user));
        } else {
          emit(PostErrorState("User not autherized"));
        }
        // log()
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });

    on<LikeAndDislike>((event, emit) async {
      try {
        await postRepo.likeAndDislike(event.postId, event.userId);
      } catch (e) {
        emit(PostErrorState("Unable action : $e"));
      }
    });

    on<AddCommentEvent>((event, emit) async {
      List<PostEntity> posts = [];
      // emit(PostLoadingState());
      try {
        await postRepo.addComment(event.postId, event.comment);
        final UserEntity? currentUser = await authRepo.getCurrentUser();
        if (currentUser != null) {
          final UserProfileEntity? user = await userprofileRepo.getuserProfile(
            currentUser.userid,
          );
          if (event.isHome == true) {
            posts = await postRepo.getAllPosts();
          } else {
            posts = await postRepo.getPostsByUserId(event.userId);
          }

          log("comment added succesfully in post bloc add comment event");
          emit(PostLoadedState(posts, user));
        } else {
          emit(PostErrorState("Unautherized user"));
        }
      } catch (e) {
        emit(PostErrorState("Error on adding comment"));
      }
    });

    on<DeleteComment>((event, emit) async {
      try {
        final UserEntity? currentUser = await authRepo.getCurrentUser();
        if (currentUser != null) {
          final UserProfileEntity? user = await userprofileRepo.getuserProfile(
            currentUser.userid,
          );
          await postRepo.deleteComment(event.postId, event.commentId);
          List<PostEntity> posts = await postRepo.getAllPosts();

          log("comment deleted succesfully in post bloc add comment event");
          emit(PostLoadedState(posts, user));
        } else {
          emit(PostErrorState("Unautherized user"));
        }
      } catch (e) {
        emit(PostErrorState("Failed to delete the comment"));
      }
    });

    on<FetchPostsByUserId>((event, emit) async {
      emit(PostLoadingState());
      try {
        final posts = await postRepo.getPostsByUserId(event.userId);
        log("got the posts based on user id --> $posts ");
        final UserProfileEntity? user = await userprofileRepo.getuserProfile(
          event.userId,
        );
        emit(PostLoadedState(posts, user));
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });
  }
}
