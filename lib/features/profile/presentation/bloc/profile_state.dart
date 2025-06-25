import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IntialProfileState extends ProfileState {}

class UserProfileUserDetailsLoadingState extends ProfileState {}

class UserProfileUserDetailsLoadedState extends ProfileState {
  final UserProfileEntity? user;
  final List<PostEntity>? posts;
  UserProfileUserDetailsLoadedState(this.user,this.posts);

  @override
  List<Object?> get props => [user,posts];
}

class UserProfileUserDetailsFailedState extends ProfileState {
  final String errorMsg;
  UserProfileUserDetailsFailedState(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}
