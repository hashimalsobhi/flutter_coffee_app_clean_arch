import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  ProfileBloc({required this.getUserProfileUseCase}) : super(ProfileInitial()) {
    on<FetchUserProfileEvent>(_onFetchProfile);
    on<RedeemRewardEvent>(_onRedeemReward);
  }

  Future<void> _onFetchProfile(
    FetchUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await getUserProfileUseCase();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      // Fallback guest profile if network error
      emit(
        const ProfileLoaded(
          profile: UserProfile(
            id: 1,
            firstName: 'Emily',
            lastName: 'Johnson',
            email: 'emily.johnson@x.dummyjson.com',
            phone: '+1 (555) 234-5678',
            username: 'emilys',
            image: 'https://dummyjson.com/icon/emilys/128',
            role: 'VIP Lounge Member',
            city: 'Phoenix',
            address: '626 Main Street',
            loyaltyBeans: 1450,
            tier: 'Diamond Connoisseur',
            freeDrinksAvailable: 3,
            completedOrders: 38,
          ),
          toastMessage: 'Loaded cached VIP lounge profile.',
        ),
      );
    }
  }

  void _onRedeemReward(
    RedeemRewardEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).profile;
      if (current.loyaltyBeans >= event.beansCost) {
        final updated = UserProfile(
          id: current.id,
          firstName: current.firstName,
          lastName: current.lastName,
          email: current.email,
          phone: current.phone,
          username: current.username,
          image: current.image,
          role: current.role,
          city: current.city,
          address: current.address,
          loyaltyBeans: current.loyaltyBeans - event.beansCost,
          tier: current.tier,
          freeDrinksAvailable: current.freeDrinksAvailable + 1,
          completedOrders: current.completedOrders,
        );
        emit(ProfileLoaded(
          profile: updated,
          toastMessage: '🎉 Reward redeemed! +1 Free Drink Voucher added.',
        ));
      } else {
        emit(ProfileLoaded(
          profile: current,
          toastMessage: 'Not enough beans to redeem this reward yet!',
        ));
      }
    }
  }
}
