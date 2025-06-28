class SearchResultEntity {
  final String userId;
  final String userName;
  final String userProfilePic;

  SearchResultEntity({
    required this.userId,
    required this.userName,
    required this.userProfilePic,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     "userId": userId,
  //     "userName": userName,
  //     "userProfilePic": userProfilePic,
  //   };
  // }

  factory SearchResultEntity.fromJson(Map<String, dynamic> json) {
    return SearchResultEntity(
      userId: json["userId"],
      userName: json["userName"] ?? "",
      userProfilePic: json["userprofilePicUrl"] ?? "",
    );
  }
}
