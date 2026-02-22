import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvData {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://stage.example.com';
  static String get storageUrl => dotenv.env['STORAGE_URL'] ?? '';
  static String get onesignalAppId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseKey => dotenv.env['SUPABASE_KEY'] ?? '';
}
