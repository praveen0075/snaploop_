import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/pages/userposts.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

class ProfilePagePostsGridView extends StatelessWidget {
  const ProfilePagePostsGridView({
    super.key,
    required this.user,
    required this.posts,
  });

  final UserProfileEntity? user;
  final List<PostEntity>? posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts!.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider<PostBloc>.value(
                        value: BlocProvider.of(context),
                        child: Userposts(
                          postUserId: user!.userid,
                          currentUser: user,
                          isHome: false,
                        ),
                      ),
                ),
              ),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                posts![index].imageUrl,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
        );
      },
    );
  }
}
