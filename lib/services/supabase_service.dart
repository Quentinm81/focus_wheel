import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    if (!url.startsWith('https://')) {
      throw Exception('Supabase URL doit être en HTTPS');
    }
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  // TODO: Add sync logic, error handling, and retry logic
}
