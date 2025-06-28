import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/domain/repositories/userprofile_repo.dart';
import 'package:snap_loop/features/search/domain/entities/search_result_entity.dart';
import 'package:snap_loop/features/search/domain/repositories/search_repo.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_event.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo searchRepo;
  final AuthRepo authRepo;
  final UserprofileRepo userprofileRepo;
  List<SearchResultEntity> allUsers = [];

  SearchBloc({
    required this.searchRepo,
    required this.authRepo,
    required this.userprofileRepo,
  }) : super(SearchInitialState()) {
    on<SearchGetAllUsers>((event, emit) async {
      emit(SearchLoadingState());

      try {
        final usersList = await searchRepo.getAllUsersForSearch();
        final UserEntity? userEntity = await authRepo.getCurrentUser();

        allUsers = usersList;
        if (userEntity != null) {
          final UserProfileEntity? user = await userprofileRepo.getuserProfile(
            userEntity.userid,
          );
          if (user != null) {
            emit(SearchLoadedState(allUsers, user));
          } else {
            emit(SearchErrorState("something went wrong internally"));
          }
        } else {
          emit(SearchErrorState("Unautherized user"));
        }
      } catch (e) {
        emit(SearchErrorState(e.toString()));
      }
    });

    on<SearchUserByName>((event, emit) async {
      final results =
          allUsers.where((user) {
            return user.userName.toLowerCase().contains(
              event.query.toLowerCase(),
            );
          }).toList();

      if (results.isEmpty) {
        emit(SearchNoResults(event.query));
      } else {
        final UserEntity? userEntity = await authRepo.getCurrentUser();
        if (userEntity != null) {
          emit(SearchLoadedState(allUsers, userEntity));
        } else {
          emit(SearchErrorState("Unautherized user"));
        }
      }
    });
  }
}
