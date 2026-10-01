import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final String? toastMessage;

  const ProfileLoaded({
    required this.profile,
    this.toastMessage,
  });

  ProfileLoaded copyWith({
    UserProfile? profile,
    String? toastMessage,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      toastMessage: toastMessage,
    );
  }

  @override
  List<Object?> get props => [profile, toastMessage];
}

class ProfileEmpty extends ProfileState {
  final String message;

  const ProfileEmpty({this.message = 'No profile information found.'});

  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
