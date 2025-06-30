
import 'package:flutter/material.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

class CurrentUserStatus extends StatelessWidget {
  const CurrentUserStatus({
    super.key,
    required this.posts,
    required this.user
  });

    final UserProfileEntity? user;
  final List<PostEntity>? posts;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(148, 104, 58, 183),
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    posts!.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(148, 104, 58, 183),
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    user!.followers.isEmpty
                        ? "0"
                        : user!.followers.length
                            .toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(148, 104, 58, 183),
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 10,
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    user!.followings.isEmpty
                        ? "0"
                        : user!.followings.length
                            .toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text("Followings"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
