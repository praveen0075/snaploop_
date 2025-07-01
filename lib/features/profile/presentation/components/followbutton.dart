import 'package:flutter/material.dart';

class Followbutton extends StatelessWidget {
  const Followbutton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
  });

  final bool isFollowing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.2, 
              color: colorScheme.outlineVariant,
            ), 
            color: isFollowing
                ? colorScheme.inversePrimary.withValues(alpha: 80)
                : colorScheme.primary,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child: Text(
              isFollowing ? "Following" : "Follow",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isFollowing
                    ? colorScheme.primary
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}