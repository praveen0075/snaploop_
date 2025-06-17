import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_textformfield.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key, required this.user});
  final UserProfileEntity? user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override 
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is UserProfileUserDetailsLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                CustomeTextformfield(
                  txtController: nameController,
                  hintText: user!.userName ?? "",
                  obscure: false,
                ),
                CustomeTextformfield(
                  txtController: bioController,
                  hintText: user!.userBio ?? "",
                  obscure: false,
                ),
              ],
            ),
          );
        }
      },
      listener: (context, state) {},
    );
  }
}
