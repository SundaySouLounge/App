import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';

class FirebaseParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FirebaseParser(
      {required this.sharedPreferencesManager, required this.apiService});
}
