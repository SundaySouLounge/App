import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:app_user/app/backend/models/profile_model.dart';

class UserProfileService extends GetxService {
  ProfileModel? _userProfile;

  void setUserProfile(ProfileModel profile) {
    _userProfile = profile;
  }

  ProfileModel? getUserProfile() {
    return _userProfile;
  }
}

