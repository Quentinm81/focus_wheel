import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    final key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    
    if (url.isEmpty || key.isEmpty) {
      throw Exception('Supabase credentials not found in .env file');
    }
    
    await Supabase.initialize(
      url: url,
      anonKey: key,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> syncData() async {
    try {
      // TODO: Implement sync logic with retry mechanism
      final user = client.auth.currentUser;
      if (user != null) {
        // Sync user data
      }
    } catch (e) {
      // Handle errors with retry logic
      rethrow;
    }
  }
}
