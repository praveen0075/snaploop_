
import 'package:equatable/equatable.dart';
import 'package:snap_loop/features/auth/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthEvent extends AuthEvent{}

class SignInEvent extends AuthEvent {
  final String userEmail;
  final String userPassword;

  SignInEvent(this.userEmail, this.userPassword);

  @override
  List<Object?> get props => [userEmail, userPassword];
}

class RegisterEvent extends AuthEvent {
  final UserEntity user;
  final String password;

  RegisterEvent(this.user,this.password);

  @override
  List<Object?> get props => [user,password];
}

class CheckCurrentUer extends AuthEvent{}

class SignOutEvent extends AuthEvent{}