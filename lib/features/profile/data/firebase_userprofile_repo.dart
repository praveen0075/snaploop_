import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/domain/repositories/userprofile_repo.dart';

class FirebaseUserProfileRepo implements UserprofileRepo {
  final FirebaseFirestore firebstore = FirebaseFirestore.instance;
  @override
  Future<UserProfileEntity?> getuserProfile(String id) async {
    final UserProfileEntity? user;
    try {
      final result =  firebstore.collection("Users");
      // final finalResult = 
      log("result of Users doc --> ${result.doc().get()}");
      final userProfileDoc = await firebstore.collection("Users").doc(id).get();
      log(userProfileDoc.toString());
      log("bool ${userProfileDoc.exists}");
      if (userProfileDoc.exists) {
        final userData = userProfileDoc.data();
        log("userdata in firebaser repo: $userData");

        if (userData != null) {
          final followers = List<String>.from(userData["followers"] ?? []);
          final followings = List<String>.from(userData["followings"] ?? []);

          user = UserProfileEntity(
            userid: id,
            userEmail: userData["userEmail"],
            userName: userData["userName"],
            userBio: userData["userBio"] ?? '',
            profilePicUrl: userData["userprofilePicUrl"] ?? '',
            followers: followers,
            followings: followings,
          );
          return user;
        }
      } else {
        log("returning null");
        return null;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(
    String userId,
    String username,
    String userBio,
    String userProfilePicUrl,
  ) async {
    try {
      await firebstore.collection("Users").doc(userId).update({
        "userName": username,
        "userBio": userBio,
        "userprofilePicUrl": userProfilePicUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> followUnFollowToggle(
    String currentUserId,
    String toggleUserid,
  ) async {
    try {
      final currentUser =
          await firebstore.collection("Users").doc(currentUserId).get();
      final toggleUser =
          await firebstore.collection("Users").doc(toggleUserid).get();

      log("current user doc collected --> $currentUser");
      log("toggle user doc collected --> $toggleUser");

      if (currentUser.exists && toggleUser.exists) {
        log("curren user adn toggle use doc exists ");

        final cUserData = currentUser.data();
        final tuserData = toggleUser.data();

        if (cUserData != null && tuserData != null) {
          log("curren user adn toggle use DATA exists  ");
          final List<String> currentFollowing = List<String>.from(
            cUserData["followings"] ?? [],
          );

          log("current user followings --> $currentFollowing");

          if (currentFollowing.contains(toggleUserid)) {
            log("current user followings contains toggle user id");
            firebstore.collection("Users").doc(currentUserId).update({
              "followings": FieldValue.arrayRemove([toggleUserid]),
            });

            firebstore.collection("Users").doc(toggleUserid).update({
              "followers": FieldValue.arrayRemove([currentUserId]),
            });
          } else {
            log("current user followings not contains toggle user id");
            firebstore.collection("Users").doc(currentUserId).update({
              "followings": FieldValue.arrayUnion([toggleUserid]),
            });

            firebstore.collection("Users").doc(toggleUserid).update({
              "followers": FieldValue.arrayUnion([currentUserId]),
            });
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
