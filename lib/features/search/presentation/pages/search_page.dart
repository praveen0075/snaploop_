import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_bloc.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_event.dart';
import 'package:snap_loop/features/search/presentation/bloc/search_state.dart';
import 'package:snap_loop/features/search/presentation/components/searchresult_list.dart';

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
    return Scaffold(
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
                        color: const Color.fromARGB(37, 104, 58, 183),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon:
                                  searchController.text.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed:
                                            () => searchController.clear(),
                                      )
                                      : Icon(Icons.search),
                              hintText: "Search",
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
                      return Center(child: CircularProgressIndicator());
                    } else if (state is SearchLoadedState) {
                      return SearchResultList(
                        scrollController: _scrollController,
                        userEntity: state.userEntity,
                        searchResults: state.searchResults,
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
