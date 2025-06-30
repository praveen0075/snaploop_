import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_delete_showdialog.dart';
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
    log("button clicked");
    context.read<ProfileBloc>().add(
      UpdateUserProfile(
        widget.user!.userid,
        bioController.text,
        nameController.text,
        _selectedProfilePic!
      ),
    );
  }

  void openBottomSheetForProfilePic() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
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
                        Icon(Icons.image),
                        Text("New profile picture"),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.grey),
                  if (widget.user!.profilePicUrl != null &&
                      widget.user!.profilePicUrl != "" &&
                      widget.user!.profilePicUrl!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        deleteShowDialog(
                          context: context,
                          onPressed: () {
                            setState(() {
                              _selectedProfilePic = null;
                            });

                            // widget.user?.profilePicUrl = "";
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          kw10,
                          Icon(Icons.delete, color: Colors.red),
                          Text(
                            "Remove Profile picture",
                            style: TextStyle(color: Colors.red),
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
    nameController.text = widget.user!.userName ?? "";
    bioController.text = widget.user!.userBio ?? "";
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile"), centerTitle: true),
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
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => openBottomSheetForProfilePic(),
                        child: CircleAvatar(
                          radius: 53,
                          backgroundColor: Colors.grey,
                          child:
                              _selectedProfilePic == null
                                  ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        widget.user!.profilePicUrl == ""
                                            ? null
                                            : NetworkImage(
                                              widget.user!.profilePicUrl!,
                                            ),
                                    child: Center(child: Icon(Icons.person)),
                                  )
                                  : CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: FileImage(
                                      _selectedProfilePic!,
                                    ),
                                    child: Center(child: Icon(Icons.person)),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  kh20,
                  Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  kh10,
                  CustomeTextformfield(
                    txtController: bioController,
                    hintText: "Bio",
                    minLine: 5,
                    maxLine: 10,
                  ),
                  kh30,
                  // Spacer(),
                  CustomButton(
                    buttonText: "Save Changes",
                    buttonColor: Colors.deepPurple,
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
