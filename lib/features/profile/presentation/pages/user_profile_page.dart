import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';
import 'package:snap_loop/features/profile/presentation/components/followbutton.dart';
import 'package:snap_loop/features/profile/presentation/components/postsgrid_in_userprofile.dart';
import 'package:snap_loop/features/profile/presentation/pages/edit_profile_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
    required this.userId,
    required this.currentUser,
  });
  final String userId;
  final UserEntity? currentUser;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(
      FetchCurrentUserDetailsEvent(widget.userId),
    );
  }

  void followbButtonclicked(List<String> followersList) {
    context.read<ProfileBloc>().add(
      FollowUnFollowButtonClickedEvent(
        widget.currentUser!.userid,
        widget.userId,
      ),
    );

    log("Button clicked and event triggered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is UserProfileUserDetailsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserProfileUserDetailsFailedState) {
            return Center(child: Text(state.errorMsg));
          } else if (state is UserProfileUserDetailsLoadedState) {
            log("followers list ${state.user!.followers.toString()}");
            return ListView(
              children: [
                CircleAvatar(
                  radius: 50,
                  child:
                      state.user!.profilePicUrl == ""
                          ? Center(child: Icon(Icons.person))
                          : Image.network(
                            state.user!.profilePicUrl!,
                            fit: BoxFit.cover,
                          ),
                  // backgroundImage:
                  //     state.user!.profilePicUrl == ""
                  //         ? null
                  //         : NetworkImage(state.user!.profilePicUrl!),
                ),
                Text(state.user!.userName!),
                Text(state.user!.userBio!),
                widget.userId == widget.currentUser!.userid
                    ? GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider<ProfileBloc>.value(
                                    value: BlocProvider.of<ProfileBloc>(
                                      context,
                                    ),
                                    child: EditProfilePage(user: state.user),
                                  ),
                            ),
                          ),
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        child: Center(child: Text("Edit Profile")),
                      ),
                    )
                    : Followbutton(
                      isFollowing: state.user!.followers.contains(
                        widget.currentUser!.userid,
                      ),
                      onPressed: () {
                        // followbButtonclicked(state.user!.followers);
                        context.read<ProfileBloc>().add(
                          FollowUnFollowButtonClickedEvent(
                            widget.currentUser!.userid,
                            widget.userId,
                          ),
                        );
                      },
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Post"),
                        Text(state.posts!.length.toString()),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Followers"),
                        Text(
                          state.user!.followers.isEmpty
                              ? "0"
                              : state.user!.followers.length.toString(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Followings"),
                        Text(
                          state.user!.followings.isEmpty
                              ? "0"
                              : state.user!.followings.length.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                PostsgridInUserprofile(
                  userId: widget.userId,
                  posts: state.posts,
                  currentUser: widget.currentUser,
                  isHome: false,
                ),
              ],
            );
          } else {
            return Center(child: Text("Something went wrong internally"));
          }
        },
      ),
    );
  }
}
