import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/search/domain/entities/search_result_entity.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<SearchResultEntity> searchResults;
  final UserEntity  userEntity;

  SearchLoadedState(this.searchResults,this.userEntity);
  @override
  List<Object?> get props => [searchResults];
}

class SearchNoResults extends SearchState {
  final String query;

  SearchNoResults(this.query);
}

class SearchErrorState extends SearchState {
  final String errormsg;

  SearchErrorState(this.errormsg);

  @override
  List<Object?> get props => [errormsg];
}
