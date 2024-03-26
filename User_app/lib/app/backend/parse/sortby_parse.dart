import 'package:app_user/app/backend/api/api.dart';
import 'package:app_user/app/helper/shared_pref.dart';

class SortByParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SortByParser(
      {required this.apiService, required this.sharedPreferencesManager});
}
