import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String username;
  final String image;
  final String role;
  final String city;
  final String address;
  final int loyaltyBeans;
  final String tier;
  final int freeDrinksAvailable;
  final int completedOrders;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.image,
    required this.role,
    required this.city,
    required this.address,
    this.loyaltyBeans = 1450,
    this.tier = 'Diamond Connoisseur',
    this.freeDrinksAvailable = 3,
    this.completedOrders = 38,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        username,
        image,
        role,
        city,
        address,
        loyaltyBeans,
        tier,
        freeDrinksAvailable,
        completedOrders,
      ];
}
