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
      log(userProfileDoc.toString());
      log("bool ${userProfileDoc.exists}");
      if (userProfileDoc.exists) {
        final userData = userProfileDoc.data();
        log("userdata : $userData");

        if (userData != null) {
          user = UserProfileEntity(
            userid: id,
            userEmail: userData["userEmail"],
            userName: userData["userName"],
            userBio: userData["userBio"] ?? '',
            profilePicUrl: userData["userprofilePicUrl"] ?? '',
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
  Future<void> updateUserProfile(UserProfileEntity userUpdatedProfile) async {
    try {
      await firebstore
          .collection("Users")
          .doc(userUpdatedProfile.userid)
          .update({
            "userBio": userUpdatedProfile.userBio,
            "userprofilePicUrl": userUpdatedProfile.profilePicUrl,
          });
    } catch (e) {
      throw Exception(e);
    }
  }
}
