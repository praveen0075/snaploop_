import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';
import 'package:snap_loop/features/profile/presentation/components/current_user_postgrid.dart';
import 'package:snap_loop/features/profile/presentation/components/current_userstatus.dart';
import 'package:snap_loop/features/profile/presentation/pages/edit_profile_page.dart';

// -------- Current app user profile page ---------//

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
            appBar: AppBar(
              title: Text("Profile"),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: Icon(Icons.settings_outlined, color: Colors.grey.shade700)),
                kw10,
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    kh20,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      bio ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
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
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.3,
                              color: Color.fromARGB(148, 104, 58, 183),
                            ),
                            borderRadius: BorderRadius.circular(20),
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
                    kh10,
                    CurrentUserStatus(posts: state.posts, user: state.user),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Divider(thickness: 0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          state.posts!.isEmpty
                              ? SizedBox(
                                height: 300,
                                child: Center(child: Text("No posts")),
                              )
                              : ProfilePagePostsGridView(
                                user: state.user,
                                posts: state.posts,
                              ),
                    ),
                  ],
                ),
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
