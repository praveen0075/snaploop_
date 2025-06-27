import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

abstract class UserprofileRepo {
  Future<UserProfileEntity?> getuserProfile(String id);
  Future<void> updateUserProfile(String userId,String username, String userBio, String userProfilePicUrl);
  Future<void> followUnFollowToggle(String currentUserId, String toggleUserid);
}
