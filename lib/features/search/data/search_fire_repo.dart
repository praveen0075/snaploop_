import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_loop/features/search/domain/entities/search_result_entity.dart';
import 'package:snap_loop/features/search/domain/repositories/search_repo.dart';

class SearchFireRepo implements SearchRepo {
  FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
  @override
  Future<List<SearchResultEntity>> getAllUsersForSearch() async {
    try {
      final userCollectionQuerySnapShot =
          await fireStoreInstance.collection("Users").get();

      log(userCollectionQuerySnapShot.toString());

      if (userCollectionQuerySnapShot.docs.isEmpty) {
        log('No user found in the database (searchfireRepo)');
        return [];
      }
      final userList =
          userCollectionQuerySnapShot.docs.map((doc) {
            final data = doc.data();
            log("user data : $data (searchfireRepo)");
            log("user names(Search repo) : ${data["userName"]} ");
            return SearchResultEntity.fromJson({
              "userId": doc.id,
              "userName ": data["userName"]??"",
              "userprofilePicUrl": data["userprofilePicUrl"] ?? "",
            });
          }).toList();
      log("Users List ---> $userList");
      return userList;
    } catch (e) {
      log("exception in getAllUserForSearch firestorerepo: $e");
      throw Exception(e);
    }
  }
}


// [log] userdata in firebaser repo: {followings: [ydjv6lYHScblkecUI3G038ucton2, nIV5wR4lLLeqUeD0OjegB5oDtIf1], userBio: eeee, userEmail: rishal@gmail.com, userprofilePicUrl: https://txqtmxbexozsugflmmjc.supabase.co/storage/v1/object/public/snaploop-user-images/profilePics/1751033979847, userName: Rishal , userId: HTYs6skiYOcbtcCL82U18EKQFcH2}