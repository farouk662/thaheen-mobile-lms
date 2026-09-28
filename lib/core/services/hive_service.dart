import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_keys.dart';

abstract final class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(AppKeys.progressBox);
  }
}
