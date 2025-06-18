import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_button.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_textformfield.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key, required this.user});
  final UserProfileEntity? user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = user!.userName ?? "";
    bioController.text = user!.userBio ?? "";
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomeTextformfield(
              txtController: nameController,
              hintText: "Name",
              obscure: false,
            ),
            kh20,
            CustomeTextformfield(
              txtController: bioController,
              hintText: "Bio",
              obscure: false,
            ),
            kh20,
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is UserProfileUserDetailsLoadedState) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state is UserProfileUserDetailsLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                return CustomButton(
                  buttonText: "Save Changes",
                  buttonColor: Colors.deepPurple,
                  buttonTextColor: Colors.white,
                  onTap:
                      () => context.read<ProfileBloc>().add(
                        UpdateUserProfile(
                          user!.userid,
                          bioController.text,
                          nameController.text,
                          UserProfileEntity(
                            userid: user!.userid,
                            userEmail: user!.userEmail,
                            userName: nameController.text.trim(),
                            userBio: bioController.text.trim(),
                            profilePicUrl: user!.profilePicUrl,
                          ),
                        ),
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
