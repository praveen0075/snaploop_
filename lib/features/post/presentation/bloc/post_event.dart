import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends PostEvent{}

class CreatePostEvent extends PostEvent {
  final PostEntity postEntity;
  CreatePostEvent(this.postEntity);

  @override
  List<Object?> get props => [postEntity];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}

class GetAllPostsEvent extends PostEvent {}
