import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Add a new user record to the 'users' table
  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await _client.from('users').insert(userData);
      print('User added: $response');
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> signUpUser(
    String email,
    String password,
    String userName,
    String role,
  ) async {
    try {
      final authResponse = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );

      final user = authResponse.user;

      if (user == null) {
        print('User creation failed');
        return null;
      }

      final newUserData = {
        'user_id': user.id, // <- Supabase UID
        'user_name': userName,
        'user_email': email.trim(),
        'role': role,
      };

      // Insert user record
      await addUser(newUserData);

      print('User registered and added to the database');
      return {'user_id': user.id, 'user_email': email.trim()};
    } catch (e) {
      print('Error during sign up: $e');
      return null;
    }
  }

  // Login user with email and password (Supabase authentication)
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      print('Logging in with email: $email');
      final authResponse = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = authResponse.user;
      if (user == null) {
        print('User is null, authentication failed');
        return null;
      }

      // Fetch user profile data from the 'users' table
      final response =
          await _client.from('users').select().eq('user_id', user.id).single();

      if (response == null) {
        print('User not found in the database');
        return null;
      }

      print('Login successful, user data fetched: $response');
      return response;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }
}
