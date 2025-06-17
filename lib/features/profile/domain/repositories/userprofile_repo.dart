import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

abstract class UserprofileRepo {
  Future<UserProfileEntity?> getuserProfile(String id);
  Future<void> updateUserProfile(UserProfileEntity userUpdatedProfile);
}
