import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthUserLoggedIn extends AuthState {
  final UserEntity? user;
  AuthUserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUserLoggedOut extends AuthState {}

class AuthFailureState extends AuthState {
  final String? errormsg;
  AuthFailureState(this.errormsg);
  @override
  List<Object?> get props => [errormsg];
}
