import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentLoggedInUserEvent extends ProfileEvents {}

class UpdateUserProfile extends ProfileEvents {
  final String userId;
  final String userBio;
  final String userName;
  final File userProfilePicUrl;

  UpdateUserProfile(
    this.userId,
    this.userBio,
    this.userName,
    this.userProfilePicUrl,
  );

  @override
  List<Object?> get props => [userId, userBio, userName, userProfilePicUrl];
}

class FetchCurrentUserDetailsEvent extends ProfileEvents {
  final String userId;
  FetchCurrentUserDetailsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FollowUnFollowButtonClickedEvent extends ProfileEvents {
  final String currentUserId;
  final String toggleUserId;

  FollowUnFollowButtonClickedEvent(this.currentUserId, this.toggleUserId);

  @override
  List<Object?> get props => [currentUserId, toggleUserId];
}
