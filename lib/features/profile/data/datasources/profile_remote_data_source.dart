import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/network_client.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final NetworkClient networkClient;

  ProfileRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<UserProfileModel> getUserProfile() async {
    final response = await networkClient.get(ApiConstants.userProfile);
    if (response != null && response is Map<String, dynamic>) {
      return UserProfileModel.fromJson(response);
    }
    throw Exception('Failed to load user profile from DummyJSON');
  }
}
