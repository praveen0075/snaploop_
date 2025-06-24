import 'package:snap_loop/features/post/domain/entities/comment_entity.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getAllPosts();
  Future<void> createPost(PostEntity postEntity);
  Future<void> deletePost(String postId);
  Future<List<PostEntity>> getPostsByUserId(String userId);
  Future<void> likeAndDislike(String postId, String userId);  
  Future<void> addComment(String postId, CommentEntity comment);  
  Future<void> deleteComment(String postId, String commentId);  
}
