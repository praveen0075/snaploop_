import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/profile/domain/entities/userprofile.dart';

abstract class ProfileEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentLoggedInUserEvent extends ProfileEvents {}

class UpdateUserProfile extends ProfileEvents {
  final String userId;
  final String userBio;
  final String userName;
  final UserProfileEntity userProfileEntiry;

  UpdateUserProfile(this.userId, this.userBio,this.userName,this.userProfileEntiry);

  @override
  List<Object?> get props => [userId, userBio,userName,userProfileEntiry];
}
