import 'package:cloud_firestore/cloud_firestore.dart';

class PostEntity {
  final String postId;
  final String userId;
  final String userName;
  final String userProfilePic;
  final String caption;
  final String imageUrl;
  final DateTime timeStamp;

  PostEntity({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userProfilePic,
    required this.caption,
    required this.imageUrl,
    required this.timeStamp,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "userId": userId,
      "userName": userName,
      "userProfilePic" : userProfilePic,
      "caption": caption,
      "imageUrl": imageUrl,
      "timeStamp": Timestamp.fromDate(timeStamp),
    };
  }

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      postId: json["postId"],
      userId: json["userId"],
      userName: json["userName"],
      userProfilePic: json["userProfilePic"],
      caption: json["caption"],
      imageUrl: json["imageUrl"],
      timeStamp: (json["timeStamp"] as Timestamp).toDate(),
    );
  }
}
