import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';
import 'package:snap_loop/features/profile/presentation/components/current_userstatus.dart';
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

  String? name;
  String? bio;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title:  Text("Profile",style: TextStyle(color:colorScheme.inversePrimary),),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is UserProfileUserDetailsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserProfileUserDetailsFailedState) {
            return Center(child: Text(state.errorMsg));
          } else if (state is UserProfileUserDetailsLoadedState) {
            name = state.user?.userName;
            bio = state.user?.userBio;

            return SingleChildScrollView(
              child: Column(
                children: [
                  kh20,
                  CircleAvatar(
                    radius: 53,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.4),
                    child: state.user!.profilePicUrl == ""  
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: colorScheme.secondary.withValues(alpha: 0.3),
                            child: const Icon(Icons.person, size: 35),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(state.user!.profilePicUrl!),
                          ),
                  ),
                  kh10,
                  Text(
                    name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  Text(
                    bio ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.inversePrimary.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  widget.userId == widget.currentUser!.userid
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<ProfileBloc>.value(
                                  value: BlocProvider.of<ProfileBloc>(context),
                                  child: EditProfilePage(user: state.user),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    colorScheme.primary.withValues(alpha: 30),
                              ),
                              child: Center(
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Followbutton(
                          isFollowing: state.user!.followers.contains(
                            widget.currentUser!.userid,
                          ),
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                                  FollowUnFollowButtonClickedEvent(
                                    widget.currentUser!.userid,
                                    widget.userId,
                                  ),
                                );
                          },
                        ),
                  kh10,
                  CurrentUserStatus(posts: state.posts, user: state.user),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Divider(thickness: 0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: state.posts!.isEmpty
                        ? SizedBox(
                            height: 300,
                            child: Center(
                              child: Text(
                                "No posts",
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        : PostsgridInUserprofile(
                            userId: widget.userId,
                            posts: state.posts,
                            currentUser: widget.currentUser,
                            isHome: false,
                          ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Something went wrong internally"));
          }
        },
      ),
    );
  }
}
