import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

abstract class PostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostInitialState extends PostState {}

class PostUpLoadingState extends PostState {}

class PostLoadingSuccessState extends PostState {}

class GetCurrentUserSuccessState extends PostState {
  final UserProfileEntity? userEntity;
  GetCurrentUserSuccessState(this.userEntity);

  @override
  List<Object?> get props => [userEntity];
}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<PostEntity> post;
  final UserProfileEntity? currentUser;
  PostLoadedState(this.post, this.currentUser);

  @override
  List<Object?> get props => [post, currentUser];
}

class PostErrorState extends PostState {
  final String errorMsg;
  PostErrorState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}


