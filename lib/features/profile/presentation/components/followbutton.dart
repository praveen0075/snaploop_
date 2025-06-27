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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(),
          color: isFollowing ? null : Colors.blue,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Center(
          child:
              isFollowing
                  ? Text("Following")
                  : Text("Follow", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
