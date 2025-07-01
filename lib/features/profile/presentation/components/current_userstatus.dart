
import 'package:flutter/material.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

class CurrentUserStatus extends StatelessWidget {
  const CurrentUserStatus({
    super.key,
    required this.posts,
    required this.user,
  });

  final UserProfileEntity? user; 
  final List<PostEntity>? posts;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = colorScheme.primary.withValues(alpha: 0.6);
    final boxBackground = colorScheme.primary.withValues(alpha: 0.05);
    final textColor = colorScheme.inversePrimary;
    final labelColor = colorScheme.inversePrimary;

    Widget buildStatBox(String value, String label) {
      return Container(
        decoration: BoxDecoration(
          color: boxBackground,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildStatBox(posts!.length.toString(), "Post"),
        buildStatBox(
            user!.followers.isEmpty
                ? "0"
                : user!.followers.length.toString(),
            "Followers"),
        buildStatBox(
            user!.followings.isEmpty
                ? "0"
                : user!.followings.length.toString(),
            "Followings"),
      ],
    );
  }
}