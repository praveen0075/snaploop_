import 'package:flutter/material.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/presentation/pages/userposts.dart';

class PostsgridInUserprofile extends StatefulWidget {
  const PostsgridInUserprofile({
    super.key,
    required this.userId,
    required this.posts,
  });
  final String userId;
  final List<PostEntity>? posts;

  @override
  State<PostsgridInUserprofile> createState() => _PostsgridInUserprofileState();
}

class _PostsgridInUserprofileState extends State<PostsgridInUserprofile> {
  @override
  void initState() {
    super.initState();
    // context.read<PostBloc>().add(FetchPostsByUserId(widget.userId));
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
          // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Userposts(post: widget.posts!, currentUser: widget.userId),)),
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
