import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getAllPosts();
  Future<void> createPost(PostEntity postEntity);
  Future<void> deletePost(String postId);
  Future<List<PostEntity>> getPostsByUserId(String userId);
}
