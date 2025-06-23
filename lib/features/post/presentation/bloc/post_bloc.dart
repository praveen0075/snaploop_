import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/helpers/supabase_storagehelper.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/domain/repositories/post_repository.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';
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
        if (imageUrl != null) {
          await postRepo.createPost(event.postEntity);
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
        emit(PostLoadedState(postList));
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });
  }
}
