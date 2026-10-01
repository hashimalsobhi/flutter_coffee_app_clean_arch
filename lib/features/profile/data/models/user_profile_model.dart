import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserAddressModel {
  final String address;
  final String city;

  const UserAddressModel({
    required this.address,
    required this.city,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) =>
      _$UserAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String username;
  final String image;
  final String? role;
  final UserAddressModel? address;

  const UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.username,
    required this.image,
    this.role,
    this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      username: username,
      image: image,
      role: role ?? 'Coffee Connoisseur',
      city: address?.city ?? 'San Francisco',
      address: address?.address ?? '742 Evergreen Terrace',
      loyaltyBeans: 1850,
      tier: 'Diamond Lounge VIP',
      freeDrinksAvailable: 4,
      completedOrders: 42,
    );
  }
}
