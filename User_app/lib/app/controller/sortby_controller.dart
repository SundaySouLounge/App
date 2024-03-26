import 'package:get/get.dart';
import 'package:app_user/app/backend/parse/sortby_parse.dart';

class SortByController extends GetxController implements GetxService {
  final SortByParser parser;

  SortByController({required this.parser});
}
