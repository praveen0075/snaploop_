import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/pages/userposts.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';
import 'package:snap_loop/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetCurrentLoggedInUserEvent());
  }

  String? name;
  String? bio;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is UserProfileUserDetailsLoadedState) {
          name = state.user?.userName;
          bio = state.user?.userBio;
          return Scaffold(
            appBar: AppBar(title: Text("Profile")),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child:
                        state.user!.profilePicUrl == ""
                            ? CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.black,
                              child: Icon(Icons.person),
                            )
                            : CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                state.user!.profilePicUrl!,
                              ),
                            ),
                  ),
                  Text(name ?? ""),
                  Text(bio ?? ""),
                  GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => BlocProvider<ProfileBloc>.value(
                                  value: BlocProvider.of<ProfileBloc>(context),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: state.posts!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemBuilder:
                          (context, index) => GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BlocProvider<PostBloc>.value(
                                          value: BlocProvider.of(context),
                                          child: Userposts(
                                            postUserId: state.user!.userid,
                                            currentUser: state.user,
                                            isHome: false,
                                          ),
                                        ),
                                  ),
                                ),
                            child: Container(
                              height: 50,
                              width: 50,

                              decoration: BoxDecoration(color: Colors.grey),
                              child: Image.network(
                                state.posts![index].imageUrl,
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            // body: Center(
            //   child: Text(
            //     "email: ${state.user!.userEmail},/n name : ${state.user!.userName ?? ""}, /n bio : ${state.user!.userBio}",
            //   ),
            // ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      listener: (context, state) {},
    );
  }
}
