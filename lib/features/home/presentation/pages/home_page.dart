import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snap_loop/features/post/presentation/components/all_post_tile.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getAllPost();
  }

  void getAllPost() {
    context.read<PostBloc>().add(GetAllPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.tertiary,
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                
                floating: true,
                snap: true,
                elevation: 0,
                backgroundColor: colorScheme.tertiary,
                title: Text(
                  "SnapLoop",
                  style: GoogleFonts.michroma(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                centerTitle: true,
              ),
            ],
        body: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is PostLoadingState || state is PostLoadingSuccessState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PostLoadedState) {
              if (state.post.isEmpty || state.post == []) {
                return Center(
                  child: Text(
                    "No post available",
                    style: TextStyle(color: colorScheme.inversePrimary),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemCount: state.post.length,
                itemBuilder: (context, index) {
                  return AllPostTile(
                    post: state.post,
                    index: index,
                    currentUser: state.currentUser,
                    isHome: true,
                    userId: state.currentUser!.userid,
                  );
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Loading",
                      style: TextStyle(color: colorScheme.inversePrimary),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
