import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/post/domain/entities/comment_entity.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends PostEvent {}

class CreatePostEvent extends PostEvent {
  final PostEntity postEntity;
  final File postFile;
  CreatePostEvent(this.postEntity, this.postFile);

  @override
  List<Object?> get props => [postEntity, postFile];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class GetAllPostsEvent extends PostEvent {}

class LikeAndDislike extends PostEvent {
  final String postId;
  final String userId;

  LikeAndDislike(this.postId, this.userId);

  @override
  List<Object?> get props => [postId, userId];
}

class AddCommentEvent extends PostEvent {
  final String postId;
  final CommentEntity comment;

  AddCommentEvent(this.postId, this.comment);

  @override
  List<Object?> get props => [postId, comment];
}

class DeleteComment extends PostEvent{
  final String postId;
  final String commentId;

  DeleteComment(this.postId, this.commentId);

  @override
  List<Object?> get props => [postId, commentId];
}
