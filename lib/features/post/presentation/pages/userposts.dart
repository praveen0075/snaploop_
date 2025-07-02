import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/post/presentation/components/all_post_tile.dart';
  import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';

class Userposts extends StatefulWidget {
  const Userposts({super.key, required this.currentUser,required this.postUserId,required this.isHome});
  // final List<PostEntity> post;
  final UserEntity? currentUser;
  final String postUserId;
  final bool isHome;

  @override
  State<Userposts> createState() => _UserpostsState();
}

class _UserpostsState extends State<Userposts> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(
      FetchPostsByUserId(widget.postUserId),
    );
  }

  // final int indx;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Posts"),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoadedState) {
            return ListView.builder(
              itemCount: state.post.length,
              itemBuilder: (context, index) {
                return AllPostTile(
                  post: state.post,
                  index: index,
                  currentUser: widget.currentUser,
                  isHome: widget.isHome,
                  userId: widget.postUserId,
                );
              },
            );
          } else if (state is PostErrorState) {
            return Center(child: Text(state.errorMsg));
          } else {
            return Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }
}
