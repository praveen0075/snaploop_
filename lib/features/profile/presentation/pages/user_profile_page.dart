import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';
import 'package:snap_loop/features/profile/presentation/components/postsgrid_in_userprofile.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.userId});
  final String userId;

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
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(child: Text("Follow")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [Text("Post"), Text("23")]),
                    Column(children: [Text("Followers"), Text("2340")]),
                    Column(children: [Text("Followings"), Text("4352")]),
                  ],
                ),
                Divider(),
                PostsgridInUserprofile(
                  userId: widget.userId,
                  posts: state.posts,
                ),

                // BlocBuilder<PostBloc, PostState>(
                //   builder: (context, state) {
                //     if (state is PostUpLoadingState) {
                //       return GridView.builder(
                //         shrinkWrap: true,
                //         itemCount: 10,
                //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 3,
                //           crossAxisSpacing: 3,
                //           mainAxisSpacing: 3,
                //         ),
                //         itemBuilder: (context, index) {
                //           return Container(color: Colors.grey);
                //         },
                //       );
                //     } else if (state is PostErrorState) {
                //       return Center(child: Text(state.errorMsg));
                //     } else if (state is PostLoadedState) {
                //       return GridView.builder(
                //         shrinkWrap: true,
                //         itemCount: state.post.length,
                //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 3,
                //           crossAxisSpacing: 3,
                //           mainAxisSpacing: 3,
                //         ),
                //         itemBuilder: (context, index) {
                //           return Container(
                //             color: Colors.grey,
                //             child: Image.network(state.post[index].imageUrl),
                //           );
                //         },
                //       );
                //     } else {
                //       return Center(child: Text("Something went wrong"));
                //     }
                //   },
                // ),
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
