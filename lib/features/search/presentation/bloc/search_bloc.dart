import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';
import 'package:snap_loop/features/search/domain/entities/search_result_entity.dart';
import 'package:snap_loop/features/search/domain/repositories/search_repo.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_event.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo searchRepo;
  final AuthRepo authRepo;
  List<SearchResultEntity> allUsers = [];

  SearchBloc({required this.searchRepo,required this.authRepo}) : super(SearchInitialState()) {
    on<SearchGetAllUsers>((event, emit) async {
      emit(SearchLoadingState());

      try {
        final usersList = await searchRepo.getAllUsersForSearch();
        final UserEntity? userEntity = await authRepo.getCurrentUser();
        allUsers = usersList;
        log("usernames --> ${allUsers[2].userName}");
        log("userids --> ${allUsers[2].userId}");
        log("userprofilepic --> ${allUsers[2].userProfilePic}");
        if(userEntity != null){
             emit(SearchLoadedState(allUsers,userEntity));
        }else{
          emit(SearchErrorState("Unautherized user"));
        }
     
      } catch (e) {
        emit(SearchErrorState(e.toString()));
      }
    });

    on<SearchUserByName>((event, emit)async{
      final results =
          allUsers.where((user) {
            return user.userName.toLowerCase().contains(
              event.query.toLowerCase(),
            );
          }).toList();

      if (results.isEmpty) {
        log("results is empty in searchuserby event in search bloc");
        emit(SearchNoResults(event.query));
      } else {
        log("user name (search bloc --> ${results[0].userName})");
         final UserEntity? userEntity = await authRepo.getCurrentUser();
       if(userEntity != null){
             emit(SearchLoadedState(allUsers,userEntity));
        }else{
          emit(SearchErrorState("Unautherized user"));
        }
      }
    });
  }
}
