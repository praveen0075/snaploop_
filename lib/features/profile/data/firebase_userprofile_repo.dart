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
      final userProfileDoc = await firebstore.collection("Users").doc(id).get();
      if (userProfileDoc.exists) {
        final userData = userProfileDoc.data();

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
    String? newUserProfilePicUrl,
  ) async {
    try {
      // await firebstore.collection("Users").doc(userId).update({
      //   "userName": username,
      //   "userBio": userBio,
      //   "userprofilePicUrl": userProfilePicUrl,
      // });
      final userRef = firebstore.collection("Users").doc(userId);
      final updateData = {"userName": username, "userBio": userBio};

      if (newUserProfilePicUrl != null) {
        updateData["userprofilePicUrl"] = newUserProfilePicUrl;
      }

      await userRef.update(updateData);
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

      if (currentUser.exists && toggleUser.exists) {
        final cUserData = currentUser.data();
        final tuserData = toggleUser.data();

        if (cUserData != null && tuserData != null) {
          final List<String> currentFollowing = List<String>.from(
            cUserData["followings"] ?? [],
          );

          if (currentFollowing.contains(toggleUserid)) {
            firebstore.collection("Users").doc(currentUserId).update({
              "followings": FieldValue.arrayRemove([toggleUserid]),
            });

            firebstore.collection("Users").doc(toggleUserid).update({
              "followers": FieldValue.arrayRemove([currentUserId]),
            });
          } else {
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
