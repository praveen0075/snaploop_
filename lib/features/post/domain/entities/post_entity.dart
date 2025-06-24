import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_loop/features/post/domain/entities/comment_entity.dart';

class PostEntity {
  final String postId;
  final String userId;
  final String userName;
  final String userProfilePic;
  final String caption;
  final String imageUrl;
  final DateTime timeStamp;
  final List<String> likes;
  final List<CommentEntity> comments;

  PostEntity({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.caption,
    required this.imageUrl,
    required this.timeStamp,
    required this.likes,
    required this.comments,
  });

  PostEntity copyWith({String? imageUrl}) {
    return PostEntity(
      postId: postId,
      userId: userId,
      userName: userName,
      userProfilePic: userProfilePic,
      caption: caption,
      imageUrl: imageUrl ?? this.imageUrl,
      timeStamp: timeStamp,
      likes: likes,
      comments: comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "userId": userId,
      "userName": userName,
      "userProfilePic": userProfilePic,
      "caption": caption,
      "imageUrl": imageUrl,
      "timeStamp": Timestamp.fromDate(timeStamp),
      "likes": likes,
      "comments": comments.map((comment) => comment.toJons()).toList(),
    };
  }

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    final List<CommentEntity> comments =
        (json["comments"] as List<dynamic>?)
            ?.map((commentJson) => CommentEntity.fromJson(commentJson))
            .toList() ??
        [];

    return PostEntity(
      postId: json["postId"],
      userId: json["userId"],
      userName: json["userName"],
      userProfilePic: json["userProfilePic"],
      caption: json["caption"],
      imageUrl: json["imageUrl"],
      timeStamp: (json["timeStamp"] as Timestamp).toDate(),
      likes: List<String>.from(json["likes"] ?? []),
      comments: comments
    );
  }
}
