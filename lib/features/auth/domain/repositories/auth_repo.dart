// This abstract contains or defines the possible operations related to the authentication.


import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<void> logInWithUserEmailAndPassword(String email, String password);
  Future<void> registerNewUser(UserEntity userEntity, String password);
  Future<void> logOut();
  Future<UserEntity?> getCurrentUser();
}


// This class will be implemented inside the auth_respository(data layaer).