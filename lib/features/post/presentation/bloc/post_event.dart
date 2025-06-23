import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends PostEvent{}

class CreatePostEvent extends PostEvent {
  final PostEntity postEntity;
  final File postFile;
  CreatePostEvent(this.postEntity,this.postFile);

  @override
  List<Object?> get props => [postEntity,postFile];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class GetAllPostsEvent extends PostEvent {}
