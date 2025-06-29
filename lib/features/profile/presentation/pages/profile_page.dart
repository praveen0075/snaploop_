import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
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
            appBar: AppBar(backgroundColor: Colors.white),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 53,
                    backgroundColor: Colors.grey,
                    child:
                        state.user!.profilePicUrl == ""
                            ? CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, size: 35),
                            )
                            : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                state.user!.profilePicUrl!,
                              ),
                            ),
                  ),
                  kh10,
                  Text(
                    name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text(
                    bio ?? "",
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(
                          //   color: const Color.fromARGB(77, 104, 58, 183),
                          // ),
                          color: const Color.fromARGB(33, 179, 166, 216),
                        ),
                        child: Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(148, 104, 58, 183),
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  state.posts!.length.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Post",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(148, 104, 58, 183),
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  state.user!.followers.isEmpty
                                      ? "0"
                                      : state.user!.followers.length.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(148, 104, 58, 183),
                          ),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  state.user!.followings.isEmpty
                                      ? "0"
                                      : state.user!.followings.length
                                          .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Text("Followings"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Divider(),
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
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      listener: (context, state) {},
    );
  }
}
