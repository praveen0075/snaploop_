import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_button.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_textformfield.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_event.dart';
import 'package:snap_loop/features/profile/presentation/bloc/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  final UserProfileEntity? user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  File? _selectedProfilePic;

  Future<void> pickTheImage() async {
    final pickResult = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (pickResult != null && pickResult.files.single.path != null) {
      setState(() {
        _selectedProfilePic = File(pickResult.files.single.path!);
      });
    }
  }

  void onSaveChanges() {
    // log(_selectedProfilePic!.path);
    context.read<ProfileBloc>().add(
      UpdateUserProfile(
        widget.user!.userid,
        bioController.text,
        nameController.text,
        _selectedProfilePic != null
            ? _selectedProfilePic!
            : File(widget.user!.profilePicUrl!)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.user!.userName ?? "";
    bioController.text = widget.user!.userBio ?? "";
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is UserProfileUserDetailsLoadedState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is UserProfileUserDetailsLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickTheImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child:
                        _selectedProfilePic == null
                            ? CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.black,
                              backgroundImage:
                                  widget.user!.profilePicUrl == ""
                                      ? null
                                      : NetworkImage(
                                        widget.user!.profilePicUrl!,
                                      ),
                              child: Center(child: Icon(Icons.person)),
                            )
                            : CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.black,
                              backgroundImage: FileImage(_selectedProfilePic!),
                              child: Center(child: Icon(Icons.person),),
                            ),
                  ),
                ),
                kh20,
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
                CustomButton(
                  buttonText: "Save Changes",
                  buttonColor: Colors.deepPurple,
                  buttonTextColor: Colors.white,
                  onTap: onSaveChanges,
                  // () => context.read<ProfileBloc>().add(
                  //   UpdateUserProfile(
                  //     widget.user!.userid,
                  //     bioController.text,
                  //     nameController.text,
                  //     "",
                  //   ),
                  // ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
