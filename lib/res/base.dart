import 'package:chat_app/utils/config.dart';

class Base {
  static const String baseTestUrl = 'http://192.168.1.12:5000';
  static const String baseProdUrl = 'http://192.168.1.12:5000';
  static const String baseUrl = AppConfig.devMode ? baseTestUrl : baseProdUrl;
}
