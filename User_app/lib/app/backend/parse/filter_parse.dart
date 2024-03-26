import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';

class FilterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FilterParser(
      {required this.apiService, required this.sharedPreferencesManager});
}
