// This entity is responsible for the user profile details that includes user ID , username, user email id and user profile pic.

class UserEntity {
  final String userid;
  final String? userName;
  final String userEmail;

  UserEntity({
    required this.userid,
    required this.userName,
    required this.userEmail,
  });

  // This is the toJson function that convert userEntity to json format
  Map<String, dynamic> toJson() {
    return {  
      "userId": userid,
      "userName": userName,
      "userEmail": userEmail,
    };
  }

  // This is the fromJson function that convert json user data that comes from databse converts into userEntity.
  factory UserEntity.fromJson(Map<String, dynamic> userJsonData) {
    return UserEntity(
      userid: userJsonData["userId"],
      userName: userJsonData["userName"],
      userEmail: userJsonData["userEmail"],
    );
  }
}
