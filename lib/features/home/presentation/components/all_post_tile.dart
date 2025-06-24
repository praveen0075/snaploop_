import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/data/auth_repository.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_textformfield.dart';
import 'package:snap_loop/features/post/domain/entities/comment_entity.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';

class AllPostTile extends StatefulWidget {
  const AllPostTile({
    super.key,
    required this.post,
    required this.index,
    this.currentUser,
  });
  final List<PostEntity> post;
  final int index;
  final UserEntity? currentUser;

  @override
  State<AllPostTile> createState() => _AllPostTileState();
}

class _AllPostTileState extends State<AllPostTile> {
  final AuthRespositoryFirebase authRepo = AuthRespositoryFirebase();
  UserEntity? userEntity;


  TextEditingController commentTextController = TextEditingController();

  void newCommentBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Add new comment"),
            content: CustomeTextformfield(
              txtController: commentTextController,
              hintText: "Comment here...",
              obscure: false,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),

              TextButton(
                onPressed: () {
                  addNewComment();
                  log("comment added");
                  
                  Navigator.pop(context);
                },
                child: Text("Send"),
              ),
            ],
          ),
    );
  }

  void addNewComment() {
    final newComment = CommentEntity(
      commentId: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post[widget.index].postId,
      userId: widget.currentUser!.userid,
      userName: widget.currentUser!.userName!,
      commentTxt: commentTextController.text,
      timeStamp: DateTime.now(),
    );

    if (commentTextController.text.isNotEmpty) {
      context.read<PostBloc>().add(
        AddCommentEvent(newComment.postId, newComment),
      );
    }
  }

  void likeAndDislike() {
    final liked = widget.post[widget.index].likes.contains(
      widget.currentUser!.userid,
    );

    setState(() {
      if (liked) {
        widget.post[widget.index].likes.remove(widget.currentUser!.userid);
      } else {
        widget.post[widget.index].likes.add(widget.currentUser!.userid);
      }
    });

    try {
      context.read<PostBloc>().add(
        LikeAndDislike(
          widget.post[widget.index].postId,
          widget.currentUser!.userid,
        ),
      );
    } catch (e) {
      setState(() {
        if (liked) {
          widget.post[widget.index].likes.add(widget.currentUser!.userid);
        } else {
          widget.post[widget.index].likes.remove(widget.currentUser!.userid);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log("comments -> ${widget.post[widget.index].comments}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.blue,
          // border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          widget.post[widget.index].userProfilePic == ""
                              ? null
                              : NetworkImage(
                                widget.post[widget.index].userProfilePic,
                              ),
                      child: Center(
                        child:
                            widget.post[widget.index].userProfilePic == ""
                                ? Center(child: Icon(Icons.person))
                                : null,
                      ),
                    ),
                    kw10,
                    Text(
                      widget.post[widget.index].userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Text("date time "),
              ],
            ),
            kh10,
            SizedBox(
              child: Image(
                image: NetworkImage(widget.post[widget.index].imageUrl),
              ),
            ),
            Row(
              children: [
                Text(
                  widget.post[widget.index].userName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(" ${widget.post[widget.index].caption}"),
              ],
            ),
            kh10,
            Row(
              children: [
                GestureDetector(
                  onTap: likeAndDislike,
                  child:
                      widget.post[widget.index].likes.contains(
                            widget.currentUser!.userid,
                          )
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border),
                ),
                Text(widget.post[widget.index].likes.length.toString()),
                kw10,
                GestureDetector(
                  onTap: newCommentBox,
                  child: Icon(Icons.comment),
                ),
                Text(widget.post[widget.index].comments.length.toString()),
                const Spacer(),
                Text(widget.post[widget.index].timeStamp.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
