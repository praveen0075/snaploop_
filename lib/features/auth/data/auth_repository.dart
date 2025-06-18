import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';
import 'package:snap_loop/features/auth/domain/repositories/auth_repo.dart';

class AuthRespositoryFirebase implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> logInWithUserEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      log("auth repo : email : $email");
      log("auth repo : password : $password");
      //login
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      log("${userCredential.user?.uid}"); 

      // user creation
      UserEntity user = UserEntity(
        userid: userCredential.user!.uid,
        userName: "",
        userEmail: email,
      );
      return user;
    } catch (e) {
      // if any error
      log("Error: $e");
      throw Exception("Failed to login: $e");
    }
  }

  @override
  Future<UserEntity?> registerNewUser(
    UserEntity userEntity,
    String password,
  ) async {
    try {
      //create new user (register)
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: userEntity.userEmail,
            password: password,
          );
      // user creation
      UserEntity user = UserEntity(
        userid: userCredential.user!.uid,
        userName: userEntity.userName,
        userEmail: userEntity.userEmail,
      );

      // save user data to the firestore
      await fireStore.collection("Users").doc(user.userid).set(user.toJson());
      return user;
    } on FirebaseAuthException catch (e) {
      // if any error
      throw Exception(e.code);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // get the current user
    final currentFireUser = firebaseAuth.currentUser;

    // if no user is logged in

    if (currentFireUser == null) {
      return null;
    }
    // user logged in
    else {
      return UserEntity(
        userid: currentFireUser.uid,
        userName: "",
        userEmail: currentFireUser.email!,
      );
    }
  }

  @override
  Future<void> logOut() async {
    // logout
    await firebaseAuth.signOut();
  }
}
