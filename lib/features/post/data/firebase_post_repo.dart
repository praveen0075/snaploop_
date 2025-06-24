import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/domain/repositories/post_repository.dart';

class FirebasePostRepo implements PostRepository {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final CollectionReference postCollectionRef = FirebaseFirestore.instance
      .collection("Posts");

  @override
  Future<void> createPost(PostEntity postEntity) async {
    try {
      postCollectionRef.doc(postEntity.postId).set(postEntity.toJson());
    } catch (e) {
      throw Exception("Error : $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postCollectionRef.doc(postId).delete();
  }

  @override
  Future<List<PostEntity>> getAllPosts() async {
    try {
      final postsData =
          await postCollectionRef.orderBy("timeStamp", descending: true).get();
      final List<PostEntity> allPost =
          postsData.docs
              .map(
                (doc) =>
                    PostEntity.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
      return allPost;
    } catch (e) {
      throw Exception("Error : $e");
    }
  }

  @override
  Future<List<PostEntity>> getPostsByUserId(String userId) async {
    try {
      final postsData =
          await postCollectionRef.where('userId', isEqualTo: userId).get();

      final posts =
          postsData.docs
              .map(
                (doc) =>
                    PostEntity.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();

      return posts;
    } catch (e) {
      throw Exception("Error : $e");
    }
  }

  @override
  Future<void> likeAndDislike(String postId, String userId) async {
    try {
      final docPost = await postCollectionRef.doc(postId).get();

      if (docPost.exists) {
        final post = PostEntity.fromJson(
          docPost.data() as Map<String, dynamic>,
        );

        final liked = post.likes.contains(userId);

        if (liked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        await postCollectionRef.doc(postId).update({"likes": post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("error : -> $e");
    }
  }
}
