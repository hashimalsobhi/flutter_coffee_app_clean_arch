import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../profile/presentation/bloc/profile_bloc.dart';
import '../../profile/presentation/bloc/profile_event.dart';
import '../../profile/presentation/bloc/profile_state.dart';
import '../widgets/state_views.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProfileBloc>();
    if (bloc.state is ProfileInitial) {
      bloc.add(FetchUserProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('VIP Lounge Membership'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Profile',
            onPressed: () => context.read<ProfileBloc>().add(FetchUserProfileEvent()),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && state.toastMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.toastMessage!),
                backgroundColor: AppColors.surfaceElevated,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const CoffeeLoadingView(message: 'Retrieving your VIP loyalty credentials...');
          }

          if (state is ProfileError) {
            return CoffeeErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileBloc>().add(FetchUserProfileEvent()),
            );
          }

          if (state is ProfileEmpty) {
            return CoffeeEmptyView(
              title: 'No Profile Found',
              message: state.message,
              onAction: () => context.read<ProfileBloc>().add(FetchUserProfileEvent()),
            );
          }

          if (state is ProfileLoaded) {
            final user = state.profile;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                children: [
                  // 1. User Header with DummyJSON Avatar
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  user.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    color: AppColors.surfaceElevated,
                                    child: const Icon(Icons.person, size: 50, color: AppColors.primary),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. Gold VIP Loyalty Coffee Pass Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF38291F), Color(0xFF1E1511)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.coffee_rounded, color: AppColors.primaryLight, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'LOUNGE BEANS CLUB',
                                  style: TextStyle(
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.primaryLight),
                              ),
                              child: Text(
                                user.tier,
                                style: const TextStyle(
                                  color: AppColors.cream,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Beans Balance',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '${user.loyaltyBeans}',
                                      style: const TextStyle(
                                        color: AppColors.cream,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'pts',
                                      style: TextStyle(
                                        color: AppColors.primaryLight,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Free Drinks',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${user.freeDrinksAvailable} Available',
                                  style: const TextStyle(
                                    color: AppColors.starGold,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Loyalty progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (user.loyaltyBeans % 500) / 500.0,
                            minHeight: 8,
                            backgroundColor: Colors.black38,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${500 - (user.loyaltyBeans % 500)} points until next artisan coffee voucher',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Redeem Reward Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.read<ProfileBloc>().add(const RedeemRewardEvent(200));
                            },
                            icon: const Icon(Icons.card_giftcard_rounded, size: 18),
                            label: const Text('Redeem 200 Beans for Free Cold Brew'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.cream,
                              side: const BorderSide(color: AppColors.primaryLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. User Details & Preferences
                  _buildSectionHeader('Profile & Preferences'),
                  const SizedBox(height: 12),
                  _buildListTile(Icons.phone_outlined, 'Phone', user.phone),
                  _buildListTile(Icons.home_outlined, 'Lounge Delivery', '${user.address}, ${user.city}'),
                  _buildListTile(Icons.history_rounded, 'Completed Orders', '${user.completedOrders} orders brewed'),

                  const SizedBox(height: 20),

                  _buildSectionHeader('Membership Settings'),
                  const SizedBox(height: 12),
                  _buildListTile(Icons.notifications_none_rounded, 'Notifications', 'Order Status & Happy Hours'),
                  _buildListTile(Icons.security_outlined, 'Data Security', 'OAuth & Biometrics Enabled'),

                  const SizedBox(height: 30),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Signed out of Specialty Lounge session.'),
                            backgroundColor: AppColors.surfaceElevated,
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
                      label: const Text(
                        'Sign Out of Lounge',
                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.cream,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.cream,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
