import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfileEvent extends ProfileEvent {}

class RedeemRewardEvent extends ProfileEvent {
  final int beansCost;

  const RedeemRewardEvent(this.beansCost);

  @override
  List<Object?> get props => [beansCost];
}
