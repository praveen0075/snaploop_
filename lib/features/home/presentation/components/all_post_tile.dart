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
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/pages/user_profile_page.dart';

class AllPostTile extends StatefulWidget {
  const AllPostTile({
    super.key,
    required this.post,
    required this.index,
    required this.currentUser,
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

  Widget commentSection() {
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(),
                title: Text("username"),
                subtitle: Text("comment"),
              );
            },
          ),
    );
  }

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
    log(
      "current user before adding the comment--> ${widget.currentUser!.userName}",
    );
    final newComment = CommentEntity(
      commentId: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post[widget.index].postId,
      userId: widget.currentUser!.userid,
      userName: widget.currentUser!.userName!,
      commentTxt: commentTextController.text,
      timeStamp: DateTime.now(),
    );

    if (commentTextController.text.isNotEmpty) {
      log("new comment --> ${newComment.commentTxt}");
      log("new comment owner --> ${newComment.userName}");
      context.read<PostBloc>().add(
        AddCommentEvent(newComment.postId, newComment),
      );
    }
  }

  void deleteAlertBox(String commentId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            // title: Text("Delete?"),
            content: Text(
              "Are you sure about this?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),

              TextButton(
                onPressed: () {
                  deleteComment(commentId);
                  Navigator.pop(context);
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void deleteComment(String commentId) {
    context.read<PostBloc>().add(
      DeleteComment(widget.post[widget.index].postId, commentId),
    );
  }

  @override
  void dispose() {
    super.dispose();
    commentTextController.dispose();
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
        decoration: BoxDecoration(),
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
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ProfileBloc>.value(
                                        value: BlocProvider.of<ProfileBloc>(
                                          context,
                                        ),
                                      ),

                                      BlocProvider.value(
                                        value: BlocProvider.of<PostBloc>(
                                          context,
                                        ),
                                      ),
                                    ],
                                    child: UserProfilePage(
                                      userId: widget.post[widget.index].userId,
                                    ),
                                  ),
                            ),
                          ),
                      child: Text(
                        widget.post[widget.index].userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                  onLongPress: commentSection,
                  onTap: newCommentBox,
                  child: Icon(Icons.comment),
                ),
                Text(widget.post[widget.index].comments.length.toString()),
                const Spacer(),
                Text(widget.post[widget.index].timeStamp.toString()),
              ],
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.post[widget.index].comments.length,
              itemBuilder: (context, index) {
                log(widget.post[widget.index].comments[index].userName);
                return SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.post[widget.index].comments[index].userName} ",
                          ),
                          Text(
                            widget
                                .post[widget.index]
                                .comments[index]
                                .commentTxt,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          deleteAlertBox(
                            widget.post[widget.index].comments[index].commentId,
                          );
                        },
                        child: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
