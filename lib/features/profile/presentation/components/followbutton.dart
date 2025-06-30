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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            color:
                isFollowing
                    ? Colors.grey.shade300
                    : const Color.fromARGB(203, 104, 58, 183),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(
            child:
                isFollowing
                    ? Text("Following", style: TextStyle(fontSize: 17))
                    : Text(
                      "Follow",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
          ),
        ),
      ),
    );
  }
}
