import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_alertbox.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/data/auth_repository.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
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
    required this.isHome,
    required this.userId,
  });
  final List<PostEntity> post;
  final int index;
  final UserEntity? currentUser;
  final bool isHome;
  final String userId;

  @override
  State<AllPostTile> createState() => _AllPostTileState();
}

class _AllPostTileState extends State<AllPostTile> {
  final AuthRespositoryFirebase authRepo = AuthRespositoryFirebase();
  UserEntity? userEntity;

  TextEditingController commentTextController = TextEditingController();

  // comment section bottom sheet //
  void showCommentsBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final comments = widget.post[widget.index].comments;

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                color: colorScheme.surface,
                child: Column(
                  children: [
                    kh10,
                    Text(
                      "All Comments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                    Expanded(
                      child:
                          comments.isEmpty
                              ? Center(
                                child: Text(
                                  "No comments yet!",
                                  style: TextStyle(
                                    color: colorScheme.inversePrimary,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                controller: scrollController,
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final sortedComments =
                                      List<CommentEntity>.from(comments)..sort(
                                        (a, b) =>
                                            b.timeStamp.compareTo(a.timeStamp),
                                      );
                                  final comment = sortedComments[index];
                                  return InkWell(
                                    onLongPress: () {
                                      if (comment.userId ==
                                          widget.currentUser!.userid) {
                                        deleteAlertBox(
                                          () =>
                                              deleteComment(comment.commentId),
                                        );
                                      }
                                    },
                                    child: ListTile(
                                      title: Text(
                                        comment.userName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: colorScheme.secondary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        comment.commentTxt,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: colorScheme.inversePrimary,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentTextController,
                              style: TextStyle(
                                color: colorScheme.inversePrimary,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorScheme.secondary.withAlpha(40),
                                hintText: "Add a comment...",
                                hintStyle: TextStyle(
                                  color: colorScheme.inversePrimary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: addNewComment,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --------  Helper functions -------- //

  // add new comment//
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
        AddCommentEvent(
          newComment.postId,
          newComment,
          widget.isHome,
          widget.userId,
        ),
      );
      setState(() {
        widget.post[widget.index].comments.add(newComment);
        commentTextController.clear();
      });
    }
  }

  // delete alert box showing function//
  void deleteAlertBox(void Function()? onPressed) {
    customAlertBox(
      context: context,
      onPressed: onPressed,
      actionButtonText: "Delete",
    );
  }

  // delete the commetn function//
  void deleteComment(String commentId) {
    context.read<PostBloc>().add(
      DeleteComment(
        widget.post[widget.index].postId,
        commentId,
        widget.isHome,
        widget.userId,
      ),
    );
    setState(() {
      widget.post[widget.index].comments.removeWhere(
        (element) => element.commentId == commentId,
      );
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    commentTextController.dispose();
  }

  // like and unlike//
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

  // ----- Builder ----//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: colorScheme.surface,
        elevation: 10,
        shadowColor: colorScheme.primary.withAlpha(100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info and delete icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.secondary,
                        child:
                            widget.post[widget.index].userProfilePic == ""
                                ? Icon(
                                  Icons.person,
                                  color: colorScheme.inversePrimary,
                                )
                                : ClipOval(
                                  child: Image.network(
                                    widget.post[widget.index].userProfilePic,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        color: colorScheme.inversePrimary,
                                      );
                                    },
                                  ),
                                ),
                      ),
                      kw10,
                      GestureDetector(
                        onTap: () {
                          final profileBloc = BlocProvider.of<ProfileBloc>(
                            context,
                          );
                          final postBloc = BlocProvider.of<PostBloc>(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ProfileBloc>.value(
                                        value: profileBloc,
                                      ),
                                      BlocProvider<PostBloc>.value(
                                        value: postBloc,
                                      ),
                                    ],
                                    child: UserProfilePage(
                                      userId: widget.post[widget.index].userId,
                                      currentUser: widget.currentUser,
                                    ),
                                  ),
                            ),
                          );
                        },
                        child: Text(
                          widget.post[widget.index].userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.post[widget.index].userId ==
                      widget.currentUser!.userid)
                    GestureDetector(
                      onTap:
                          () => deleteAlertBox(() {
                            context.read<PostBloc>().add(
                              DeletePostEvent(widget.post[widget.index].postId),
                            );
                            Navigator.pop(context);
                          }),
                      child: Icon(
                        Icons.delete_outline_outlined,
                        color: colorScheme.secondary,
                      ),
                    ),
                ],
              ),
              kh10,
              // Post image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.post[widget.index].imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
              kh10,
              // Like and comment section
              Row(
                children: [
                  GestureDetector(
                    onTap: likeAndDislike,
                    child:
                        widget.post[widget.index].likes.contains(
                              widget.currentUser!.userid,
                            )
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(
                              Icons.favorite_border,
                              color: colorScheme.inversePrimary,
                            ),
                  ),
                  Text(
                    widget.post[widget.index].likes.length.toString(),
                    style: TextStyle(color: colorScheme.inversePrimary),
                  ),
                  kw10,
                  GestureDetector(
                    onTap: showCommentsBottomSheet,
                    child: Icon(
                      Icons.comment,
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  Text(
                    widget.post[widget.index].comments.length.toString(),
                    style: TextStyle(color: colorScheme.inversePrimary),
                  ),
                  Spacer(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Text(
                      widget.post[widget.index].userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      " ${widget.post[widget.index].caption}",
                      style: TextStyle(color: colorScheme.inversePrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
