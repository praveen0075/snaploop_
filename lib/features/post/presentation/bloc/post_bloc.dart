import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/domain/repositories/post_repository.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepo;
  final AuthRepo authRepo;

  PostBloc({required this.postRepo, required this.authRepo})
    : super(PostInitialState()) {
    on<GetCurrentUserEvent>((event, emit) async{
      emit(PostLoadingState());
      try {
        final user = await authRepo.getCurrentUser();
        log(user!.userEmail);
        emit(GetCurrentUserSuccessState(user));
      } catch (e) {
        emit(PostErrorState(e.toString()));
      }
    });

    on<CreatePostEvent>((event, emit) async {
      emit(PostLoadingState());
      try {
        await postRepo.createPost(event.postEntity);
        emit(PostLoadingSuccessState());
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
