import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_alertbox.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/core/components/custom_button.dart';
import 'package:snap_loop/core/components/custom_textformfield.dart';
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
  String? _userdp;

  Future<void> pickTheImage() async {
    try {
      final pickResult = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (pickResult != null && pickResult.files.single.path != null) {
        setState(() {
          _selectedProfilePic = File(pickResult.files.single.path!);
        });
      } 
    } catch (e) {
      if (mounted) {
        customSnackBar(
          context,
          "Something went wrong while picking the file",
          Colors.white,
          Colors.red,
        );
      }
    }
  }

  void onSaveChanges() {

    if (_selectedProfilePic == null) {
      _userdp = widget.user!.profilePicUrl;
    } else {
      _userdp = _selectedProfilePic!.path;
    }

    context.read<ProfileBloc>().add(
      UpdateUserProfile(
        widget.user!.userid,
        bioController.text,
        nameController.text,
        _userdp,
      ),
    );
  }

  void openBottomSheetForProfilePic() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      backgroundColor: colorScheme.surface.withValues(alpha: 0.97),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 100,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickTheImage();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        kw10,
                        Icon(Icons.image, color: colorScheme.inversePrimary),
                        Text(
                          "New profile picture",
                          style: TextStyle(color: colorScheme.inversePrimary),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 0, color: colorScheme.outlineVariant),
                  if (widget.user!.profilePicUrl != null &&
                      widget.user!.profilePicUrl!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        customAlertBox(
                          actionButtonText: "Delete",
                          context: context,
                          onPressed: () {
                            setState(() {
                              _selectedProfilePic = File("");
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          kw10,
                          Icon(Icons.delete, color: colorScheme.error),
                          Text(
                            "Remove Profile picture",
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    nameController.text = widget.user!.userName ?? "";
    bioController.text = widget.user!.userBio ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is UserProfileUserDetailsLoadedState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is UserProfileUserDetailsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: openBottomSheetForProfilePic,
                        child: CircleAvatar(
                          radius: 53,
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          child:
                              _selectedProfilePic == null
                                  ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: colorScheme.secondary
                                        .withValues(alpha: 0.3),
                                    backgroundImage:
                                        widget.user!.profilePicUrl == ""
                                            ? null
                                            : NetworkImage(
                                              widget.user!.profilePicUrl!,
                                            ),
                                    child: const Icon(Icons.person),
                                  )
                                  : CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: FileImage(
                                      _selectedProfilePic!,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: colorScheme.inversePrimary,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  kh20,
                  Text(
                    "Username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  kh10,
                  CustomeTextformfield(
                    txtController: nameController,
                    hintText: "Name",
                    minLine: 1,
                    maxLine: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the username";
                      }
                      return null;
                    },
                  ),
                  kh20,
                  Text(
                    "Userbio",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.inversePrimary,
                    ),
                  ),
                  kh10,
                  CustomeTextformfield(
                    txtController: bioController,
                    hintText: "Bio",
                    minLine: 5,
                    maxLine: 10,
                  ),
                  kh30,
                  CustomButton(
                    buttonText: "Save Changes",
                    buttonColor: colorScheme.primary,
                    buttonTextColor: Colors.white,
                    onTap: onSaveChanges,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
