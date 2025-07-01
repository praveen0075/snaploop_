import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_delete_showdialog.dart';
import 'package:snap_loop/core/constants/kcolors.dart';
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
              return Column(
                children: [
                  kh10,
                  Text(
                    "All Comments",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child:
                        comments.isEmpty
                            ? Center(child: Text("No comments yet!"))
                            : ListView.builder(
                              controller: scrollController,
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final sortedComments = List<CommentEntity>.from(
                                  widget.post[widget.index].comments,
                                )..sort(
                                  (a, b) => b.timeStamp.compareTo(a.timeStamp),
                                );
                                final comment = sortedComments[index];
                                return InkWell(
                                  onLongPress: () {
                                    comment.userId == widget.currentUser!.userid
                                        ? deleteAlertBox(
                                          () =>
                                              deleteComment(comment.commentId),
                                        )
                                        : null;
                                  },
                                  child: ListTile(
                                    title: Text(
                                      comment.userName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    subtitle: Text(
                                      comment.commentTxt,
                                      style: TextStyle(fontSize: 15),
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kTextFieldFilledColor,
                              hintText: "Add a comment...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: addNewComment,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    deleteShowDialog(context: context, onPressed: onPressed);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: kAppBaseClr,
        child: Padding(
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
                                          userId:
                                              widget.post[widget.index].userId,
                                          currentUser: widget.currentUser,
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
                    widget.post[widget.index].userId ==
                            widget.currentUser!.userid
                        ? GestureDetector(
                          onTap:
                              () => deleteAlertBox(() {
                                context.read<PostBloc>().add(
                                  DeletePostEvent(
                                    widget.post[widget.index].postId,
                                  ),
                                );
                                Navigator.pop(context);
                              }),

                          child: Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.grey,
                          ),
                        )
                        : SizedBox(width: 2),
                  ],
                ),
                kh10,
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
                      // onLongPress: commentSection,
                      onTap: showCommentsBottomSheet,
                      child: Icon(Icons.comment),
                    ),
                    Text(widget.post[widget.index].comments.length.toString()),
                    const Spacer(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Text(
                        widget.post[widget.index].userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text(" ${widget.post[widget.index].caption}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
