import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_loop/core/components/custom_snackbar.dart';
import 'package:snap_loop/core/components/custom_textformfield.dart';
import 'package:snap_loop/core/constants/ksizedboxes.dart';
import 'package:snap_loop/core/components/custom_button.dart';
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
        likes: [],
        comments: [],
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
  final colorScheme = Theme.of(context).colorScheme;

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
          "Posted successfully",
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
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              "Add Post",
              style: TextStyle(color: colorScheme.inversePrimary),
            ),
            backgroundColor: colorScheme.surface,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: colorScheme.inversePrimary),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.primary),
                          image: pickedFile == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(pickedFile!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: pickedFile == null
                            ? Center(
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: colorScheme.inversePrimary,
                                  size: 40,
                                ),
                              )
                            : null,
                      ),
                    ),
                    kh20,
                    CustomeTextformfield(
                      filledColor: colorScheme.surface,
                      txtController: captionController,
                      hintText: "Caption",
                      minLine: 3,
                      maxLine: 5,
             
                    ),
                  ],
                ),
                CustomButton(
                  buttonText: "Submit",
                  buttonColor: colorScheme.primary,
                  buttonTextColor: Colors.white,
                  onTap: uploadPost,
                ),
              ],
            ),
          ),
        );
      } else {
        return Center(
          child: Text(
            "Loading user info...",
            style: TextStyle(color: colorScheme.inversePrimary),
          ),
        );
      }
    },
  );
}
}