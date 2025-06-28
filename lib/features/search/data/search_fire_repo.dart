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
              "userName": data["userName"] ?? "",
              "userprofilePicUrl": data["userprofilePicUrl"] ?? "",
            });
          }).toList();
      log("Username (search fire repo) --> ${userList[0].userName}");
      log("Users List ---> $userList");
      return userList;
    } catch (e) {
      log("exception in getAllUserForSearch firestorerepo: $e");
      throw Exception(e);
    }
  }
}
