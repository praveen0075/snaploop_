import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/home/presentation/components/all_post_tile.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';

class Userposts extends StatelessWidget {
  const Userposts({super.key, required this.post, required this.currentUser});
  final List<PostEntity> post;
  final UserEntity? currentUser;
  // final int indx;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: post.length,
        itemBuilder: (context, index) {
          return AllPostTile(
            post: post,
            index: index,
            currentUser: currentUser,
          );
        },
      ),
    );
  }
}
