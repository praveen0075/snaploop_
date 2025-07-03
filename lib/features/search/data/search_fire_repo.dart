
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


      if (userCollectionQuerySnapShot.docs.isEmpty) {
        return [];
      }
      final userList =
          userCollectionQuerySnapShot.docs.map((doc) {
            final data = doc.data();
            return SearchResultEntity.fromJson({
              "userId": doc.id,
              "userName": data["userName"] ?? "",
              "userprofilePicUrl": data["userprofilePicUrl"] ?? "",
            });
          }).toList();
      return userList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
