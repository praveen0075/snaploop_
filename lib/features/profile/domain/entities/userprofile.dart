import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';

class UserProfileEntity extends UserEntity {
  final String? userBio;
  final String? profilePicUrl;
  final List<String> followers;
  final List<String> followings;

  UserProfileEntity({
    required super.userid,
    required super.userEmail,
    required super.userName,
    required this.userBio,
    required this.profilePicUrl,
    required this.followers,
    required this.followings
  });

  // This is the method that help to update the user details.
  UserProfileEntity copyWith({String? newBio, String? newProfilePicUrl,List<String>? newfollowers,List<String>? newfollowings}) {
    return UserProfileEntity(
      userid: userid,
      userEmail: userEmail,
      userName: userName,
      userBio: newBio ?? userBio,
      profilePicUrl: newProfilePicUrl ?? profilePicUrl,
      followers: newfollowers ?? followers,
      followings: newfollowings ?? followings
    );
  }

  // Converting UserProfileEntity to json format
  Map<String, dynamic> toJson() {
    return {
      "userId": userid,
      "userName": userName,
      "userEmail": userEmail,
      "userBio": userBio,
      "userprofilePicUrl": profilePicUrl,
      "followers" : followers,
      "followings" : followings
    };
  }

  // converting json data user details to userprofile
  factory UserProfileEntity.fromJson(Map<String, dynamic> json) {
    return UserProfileEntity(
      userid: json["userId"],
      userEmail: json["userEmail"],
      userName: json["userName"] ?? '',
      userBio: json["userBio"] ?? '',
      profilePicUrl: json["userprofilePicUrl"] ?? '',
      followers: List<String>.from(json["followers"]?? []),
      followings: List <String>.from(json["followings"] ?? [] )
    );
  }
}
