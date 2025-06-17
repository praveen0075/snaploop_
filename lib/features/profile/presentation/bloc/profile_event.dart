import 'package:equatable/equatable.dart';

abstract class ProfileEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentLoggedInUserEvent extends ProfileEvents {}

class UpdateUserProfile extends ProfileEvents {
  final String userId;
  final String userBio;

  UpdateUserProfile(this.userId, this.userBio);

  @override
  List<Object?> get props => [userId, userBio];
}
