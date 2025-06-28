import 'package:snap_loop/features/search/domain/entities/search_result_entity.dart';

abstract class SearchRepo {
  Future<List<SearchResultEntity>> getAllUsersForSearch();
}
