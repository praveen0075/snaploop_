
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/pages/user_profile_page.dart';
import 'package:snap_loop/features/search/domain/entities/search_result_entity.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required ScrollController scrollController,
    required this.userEntity,
    required this.searchResults,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final UserEntity userEntity;
  final List<SearchResultEntity> searchResults;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: searchResults.length,
      // itemCount: 50,
      itemBuilder: (context, index) {
        final user = searchResults[index];
        return ListTile( 
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey,
              backgroundImage:
                  user.userProfilePic == ""
                      ? null
                      : NetworkImage(user.userProfilePic),
              child: user.userProfilePic == "" ? Icon(Icons.person) : null,
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider<ProfileBloc>.value(
                            value: BlocProvider.of<ProfileBloc>(context),
                          ),
                          BlocProvider<PostBloc>.value(
                            value: BlocProvider.of<PostBloc>(context),
                          ),
                        ],
                        child: UserProfilePage(
                          userId: user.userId,
                          currentUser: userEntity,
                        ),
                      ),
                ),
              );
            },
            child: Text(user.userName, style: TextStyle(color: Colors.black,)),
          ),
        );
      },
    );
  }
}
