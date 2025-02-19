part of 'user_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String? image;
  final String password;

  const SignUpEvent({required this.name, required this.email, required this.password, required this.image});
}

class SendOTPEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String? image;
  final String password;
  final int otp;

  const SendOTPEvent({required this.name, required this.email, required this.password, required this.image, required this.otp});
}

class SignInEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});
}

class PasswordUpdateEvent extends AuthenticationEvent {
  final String id;
  final String newPassword;

  const PasswordUpdateEvent({required this.id, required this.newPassword});
}

class GetUserByEmailEvent extends AuthenticationEvent {
  final String email;

  const GetUserByEmailEvent({required this.email});
}
