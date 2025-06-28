import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/pages/user_profile_page.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_bloc.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_event.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchGetAllUsers());

    searchController.addListener(() {
      final text = searchController.text.trim();
      if (text.isEmpty) {
        context.read<SearchBloc>().add(SearchUserByName(""));
      } else {
        context.read<SearchBloc>().add(SearchUserByName(text));
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon:
                            searchController.text.isNotEmpty
                                ? Icon(Icons.clear)
                                : Icon(Icons.search),
                        hintText: "Search",
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is SearchLoadedState) {
                      return ListView.builder(
                        itemCount: state.searchResults.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final user = state.searchResults[index];
                          log("username is ${user.userName}");
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  user.userProfilePic == ""
                                      ? null
                                      : NetworkImage(user.userProfilePic),
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
                                              value:
                                                  BlocProvider.of<ProfileBloc>(
                                                    context,
                                                  ),
                                            ),

                                            BlocProvider.value(
                                              value: BlocProvider.of<PostBloc>(
                                                context,
                                              ),
                                            ),
                                          ],
                                          child: UserProfilePage(
                                            userId:
                                                state
                                                    .searchResults[index]
                                                    .userId,
                                            currentUser: state.userEntity,
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                user.userName,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is SearchNoResults) {
                      return Center(
                        child: Text("No result for ${state.query}"),
                      );
                    } else if (state is SearchErrorState) {
                      return Center(child: Text(state.errormsg));
                    } else {
                      return Center(child: Text("Something went wrong"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
