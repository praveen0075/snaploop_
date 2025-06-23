import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/features/auth/presentation/components/custom_button.dart';
import 'package:snap_loop/features/post/domain/entities/post_entity.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_bloc.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_event.dart';
import 'package:snap_loop/features/post/presentation/bloc/post_state.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File? pickedFile;
  UserProfileEntity? currentUser;
  // String? imageUrl;

  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(GetCurrentUserEvent());
  }

  void pickImage() async {
    final pickedResult = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (pickedResult != null && pickedResult.files.single.path != null) {
      setState(() {
        pickedFile = File(pickedResult.files.single.path!);
      });
    }
  }

  void uploadPost() {
    // pickedFile = "assets/images/naruto.jpg";
    if (pickedFile == null || captionController.text.isEmpty) {
      customSnackBar(
        context,
        "Both image and caption are required",
        Colors.white,
        Colors.red,
      );
      return;
    } else {
      final post = PostEntity(
        postId: DateTime.now().microsecondsSinceEpoch.toString(),
        userId: currentUser!.userid,
        userName: currentUser!.userName!,
        userProfilePic: currentUser!.profilePicUrl!,
        caption: captionController.text,
        imageUrl: pickedFile!.path,
        timeStamp: DateTime.now(),
      );
      context.read<PostBloc>().add(CreatePostEvent(post, pickedFile!));
    }
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is GetCurrentUserSuccessState) {
          setState(() {
            currentUser = state.userEntity;
          });
        } else if (state is PostLoadingSuccessState) {
          captionController.clear();
          pickedFile = null;
          customSnackBar(
            context,
            "posted Successfully",
            Colors.white,
            Colors.green,
          );
        } else if (state is PostErrorState) {
          customSnackBar(context, state.errorMsg, Colors.white, Colors.red);
        }
      },
      builder: (context, state) {
        if (state is PostLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (currentUser != null || state is PostLoadingSuccessState) {
          return Scaffold(
            appBar: AppBar(title: Text("Add Post")),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(),
                            image:
                                pickedFile == null
                                    ? null
                                    : DecorationImage(
                                      image: FileImage(pickedFile!),
                                    ),
                          ),
                          child: Center(
                            child: Icon(Icons.add_photo_alternate_outlined),
                          ),
                        ),
                      ),
                      kh20,
                      TextField(
                        controller: captionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Caption",
                          hintStyle: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    buttonText: "Submit",
                    buttonColor: Colors.deepPurple,
                    buttonTextColor: Colors.white,
                    onTap: uploadPost,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text("Loading user info..."));
        }
      },
    );
  }
}
