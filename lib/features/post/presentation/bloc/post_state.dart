import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitialState extends PostState {}

class PostUpLoadingState extends PostState {}

class PostLoadingSuccessState extends PostState{}

class GetCurrentUserSuccessState extends PostState{
  final UserEntity? userEntity;
  GetCurrentUserSuccessState(this.userEntity);

  @override
  List<Object?> get props => [userEntity];
}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<PostEntity> post;
  PostLoadedState(this.post);

  @override
  List<Object?> get props => [post];
}

class PostErrorState extends PostState {
  final String errorMsg;
  PostErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}
