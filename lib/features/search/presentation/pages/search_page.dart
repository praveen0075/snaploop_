import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showSearchBar = true;

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

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showSearchBar) {
          setState(() {
            _showSearchBar = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showSearchBar) {
          setState(() {
            _showSearchBar = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              kh10,
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _showSearchBar ? 50 : 0,
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: _showSearchBar ? 1.0 : 0.0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: colorScheme.inversePrimary),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: colorScheme.inversePrimary,
                              ),
                              suffixIcon:
                                  searchController.text.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: colorScheme.inversePrimary,
                                        ),
                                        onPressed:
                                            () => searchController.clear(),
                                      )
                                      : Icon(
                                        Icons.search,
                                        color: colorScheme.inversePrimary,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              kh10,
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      );
                    } else if (state is SearchLoadedState) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: state.searchResults.length,
                        itemBuilder: (context, index) {
                          final user = state.searchResults[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: colorScheme.secondary,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: colorScheme.tertiary,
                                backgroundImage:
                                    user.userProfilePic == ""
                                        ? null
                                        : NetworkImage(user.userProfilePic),
                                child:
                                    user.userProfilePic == ""
                                        ? Icon(
                                          Icons.person,
                                          color: colorScheme.inversePrimary,
                                        )
                                        : null,
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
                                              value:
                                                  BlocProvider.of<ProfileBloc>(
                                                    context,
                                                  ),
                                            ),
                                            BlocProvider<PostBloc>.value(
                                              value: BlocProvider.of<PostBloc>(
                                                context,
                                              ),
                                            ),
                                          ],
                                          child: UserProfilePage(
                                            userId: user.userId,
                                            currentUser: state.userEntity,
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                user.userName,
                                style: TextStyle(
                                  color: colorScheme.inversePrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is SearchNoResults) {
                      return Center(
                        child: Text(
                          "No result for '${state.query}'",
                          style: TextStyle(color: colorScheme.inversePrimary),
                        ),
                      );
                    } else if (state is SearchErrorState) {
                      return Center(
                        child: Text(
                          state.errormsg,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "Something went wrong",
                          style: TextStyle(color: colorScheme.inversePrimary),
                        ),
                      );
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
