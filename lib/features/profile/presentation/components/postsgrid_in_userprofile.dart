import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/pages/userposts.dart';

class PostsgridInUserprofile extends StatefulWidget {
  const PostsgridInUserprofile({
    super.key,
    required this.userId,
    required this.posts,
    required this.currentUser,
    required this.isHome,
  });
  final String userId;
  final List<PostEntity>? posts;
  final UserEntity? currentUser;
  final bool isHome;

  @override
  State<PostsgridInUserprofile> createState() => _PostsgridInUserprofileState();
}

class _PostsgridInUserprofileState extends State<PostsgridInUserprofile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.posts!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider<PostBloc>.value(
                      value: BlocProvider.of(context),
                      child: Userposts(
                        postUserId: widget.userId,
                        currentUser: widget.currentUser,
                        isHome: widget.isHome,
                      ),
                    );
                  },
                ),
              ),
          child: Container(
            color: Colors.grey,
            child: Image.network(
              widget.posts![index].imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
