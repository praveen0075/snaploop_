import 'package:flutter/material.dart';
import 'package:snap_loop/features/auth/data/auth_repository.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final AuthRespositoryFirebase authRepo = AuthRespositoryFirebase();

  late Future<UserEntity?> currenUser =  authRepo.getCurrentUser();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Profile Page")));
  }
}
