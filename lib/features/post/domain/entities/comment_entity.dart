import 'package:cloud_firestore/cloud_firestore.dart';

class CommentEntity {
  final String commentId;
  final String postId;
  final String userId;
  final String userName;
  final String commentTxt;
  final DateTime timeStamp;

  CommentEntity({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.commentTxt,
    required this.timeStamp,
  });

  Map<String, dynamic> toJons() {
    return {
      "commentId": commentId,
      "postId": postId,
      "userId": userId,
      "userName": userName,
      "commentTxt": commentTxt,
      "timeStamp": Timestamp.fromDate(timeStamp),
    };
  }

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    return CommentEntity(
      commentId: json["commentId"],
      postId: json["postId"],
      userId: json["userId"],
      userName: json["userName"],
      commentTxt: json["commentTxt"],
      timeStamp: (json["timeStamp"]as Timestamp).toDate(),
    );
  }
}
