import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';
import 'package:snap_loop/features/profile/presentation/components/current_user_postgrid.dart';
import 'package:snap_loop/features/profile/presentation/components/current_userstatus.dart';
import 'package:snap_loop/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:snap_loop/features/settings/presentation/pages/settings_page.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is UserProfileUserDetailsLoadedState) {
          name = state.user?.userName;
          bio = state.user?.userBio;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              title: const Text("Profile"),
              backgroundColor: colorScheme.surface,
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: BlocProvider.of<AuthBloc>(context),
                              child: const SettingsPage(),
                            ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.settings_outlined,
                    color: colorScheme.inversePrimary.withValues(alpha: 0.9),
                  ),
                ),
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
                      backgroundColor: colorScheme.primary.withAlpha(100),
                      child:
                          state.user!.profilePicUrl == ""
                              ? CircleAvatar(
                                radius: 50,
                                backgroundColor: colorScheme.secondary
                                    .withAlpha(77),
                                child: Icon(
                                  Icons.person,
                                  size: 35,
                                  color: colorScheme.inversePrimary,
                                ),
                              )
                              : ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    state.user!.profilePicUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return CircleAvatar(
                                        radius: 50,
                                        backgroundColor: colorScheme.secondary
                                            .withAlpha(77),
                                        child: Icon(
                                          Icons.person,
                                          size: 35,
                                          color: colorScheme.inversePrimary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
                        color: colorScheme.inversePrimary.withValues(
                          alpha: 0.7,
                        ),
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
                              width: 0.8,
                              color: colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: colorScheme.primary.withValues(alpha: 0.1),
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
                    ),
                    kh10,
                    CurrentUserStatus(posts: state.posts, user: state.user),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Divider(thickness: 0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          state.posts!.isEmpty
                              ? const SizedBox(
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
          return const Center(child: CircularProgressIndicator());
        }
      },
      listener: (context, state) {},
    );
  }
}
