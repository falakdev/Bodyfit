import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isAuthenticated = false;
  String? _email;
  User? _user;
  bool _useFirebase = true; // Track if Firebase is available

  bool get isAuthenticated => _isAuthenticated;
  String? get email => _email;
  User? get user => _user;

  AuthProvider() {
    // Check if Firebase is properly initialized
    try {
      _auth.authStateChanges().listen((User? user) {
        _user = user;
        _isAuthenticated = user != null;
        _email = user?.email;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Firebase not available, using local mode: $e');
      _useFirebase = false;
    }
  }

  Future<void> tryAutoLogin() async {
    if (_useFirebase) {
      final user = _auth.currentUser;
      if (user != null) {
        _user = user;
        _email = user.email;
        _isAuthenticated = true;
        notifyListeners();
        return;
      }
    }
    
    // Fallback to SharedPreferences for local authentication
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('auth_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _email = savedEmail;
      _isAuthenticated = true; // Allow auto-login with local auth
      debugPrint('Auto-login with local authentication: $savedEmail');
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      if (email.isEmpty || password.length < 6) {
        throw Exception('Invalid credentials');
      }

      // Try Firebase first
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        _user = userCredential.user;
        _email = userCredential.user?.email;
        _isAuthenticated = true;

        // Save to SharedPreferences for backward compatibility
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_email', email.trim());
        
        debugPrint('User logged in via Firebase: ${userCredential.user?.uid}');
        notifyListeners();
        return;
      } on FirebaseAuthException catch (e) {
        // If API key error, fall back to local mode
        final message = e.message ?? '';
        if (e.code.contains('api-key') || message.contains('api-key')) {
          debugPrint('Firebase not configured, using local authentication');
          _useFirebase = false;
          // Fall through to local authentication
        } else {
          // Other Firebase errors - rethrow
          String errorMessage = 'Login failed';
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'No user found with this email';
              break;
            case 'wrong-password':
              errorMessage = 'Wrong password provided';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email address';
              break;
            case 'user-disabled':
              errorMessage = 'This account has been disabled';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many failed attempts. Please try again later';
              break;
            default:
              errorMessage = e.message ?? 'Login failed';
          }
          throw Exception(errorMessage);
        }
      }
      
      // Fallback to local authentication
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('auth_email');
      final savedPassword = prefs.getString('auth_password');
      
      debugPrint('=== LOCAL LOGIN DEBUG ===');
      debugPrint('Input Email: "${email.trim()}"');
      debugPrint('Saved Email: "$savedEmail"');
      debugPrint('Input Password length: ${password.length}');
      debugPrint('Saved Password length: ${savedPassword?.length ?? 0}');
      debugPrint('Email match: ${savedEmail?.toLowerCase() == email.trim().toLowerCase()}');
      debugPrint('Password match: ${savedPassword == password}');
      debugPrint('========================');
      
      if (savedEmail == null || savedEmail.isEmpty) {
        debugPrint('ERROR: No saved email found in SharedPreferences');
        throw Exception('No account found with this email. Please sign up first.');
      }
      
      if (savedPassword == null || savedPassword.isEmpty) {
        debugPrint('ERROR: No saved password found in SharedPreferences');
        throw Exception('Account data is incomplete. Please sign up again.');
      }
      
      // Check email (case-insensitive)
      if (savedEmail.toLowerCase() != email.trim().toLowerCase()) {
        debugPrint('ERROR: Email mismatch');
        debugPrint('  Input: "${email.trim().toLowerCase()}"');
        debugPrint('  Saved: "${savedEmail.toLowerCase()}"');
        throw Exception('No account found with this email. Please sign up first.');
      }
      
      // Check password (case-sensitive, exact match)
      if (savedPassword != password) {
        debugPrint('ERROR: Password mismatch');
        debugPrint('  Input: "${password.substring(0, password.length > 3 ? 3 : password.length)}..." (length: ${password.length})');
        debugPrint('  Saved: "${savedPassword.substring(0, savedPassword.length > 3 ? 3 : savedPassword.length)}..." (length: ${savedPassword.length})');
        throw Exception('Invalid password. Please check your password and try again.');
      }
      
      // Success - credentials match
      _email = email.trim();
      _isAuthenticated = true;
      debugPrint('✅ Login successful via local authentication');
      notifyListeners();
    } catch (e) {
      debugPrint('Login error: $e');
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      if (name.isEmpty || email.isEmpty || password.length < 6) {
        throw Exception('Please fill all fields (password 6+ chars)');
      }

      // Try Firebase first
      try {
        // Create user in Firebase Auth
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

        // Update display name
        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(name);
          await userCredential.user!.reload();
          _user = _auth.currentUser;
        }

        // Save user data to Firestore
        if (userCredential.user != null) {
          try {
            await _firestore.collection('users').doc(userCredential.user!.uid).set({
              'uid': userCredential.user!.uid,
              'email': email.trim(),
              'name': name,
              'createdAt': FieldValue.serverTimestamp(),
              'lastLogin': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            debugPrint('User created and saved to Firestore: ${userCredential.user!.uid}');
          } catch (firestoreError) {
            debugPrint('Error saving to Firestore: $firestoreError');
            // Attempt to rollback the created Auth user to avoid orphan accounts
            try {
              debugPrint('Attempting to delete the newly created auth user to rollback...');
              await userCredential.user!.delete();
              debugPrint('Rolled back newly created auth user due to Firestore failure');
            } catch (deleteErr) {
              debugPrint('Failed to delete auth user after Firestore failure: $deleteErr');
            }

            // Remove any saved credentials that were stored earlier
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_email');
              await prefs.remove('auth_name');
            } catch (prefsErr) {
              debugPrint('Failed to clear saved credentials after rollback: $prefsErr');
            }

            // Surface the Firestore error to the caller/UI
            throw Exception('Failed to save user profile to Firestore: $firestoreError');
          }
        }

        _email = userCredential.user?.email;
        _isAuthenticated = true;

        // Save to SharedPreferences for backward compatibility
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_email', email.trim());
        await prefs.setString('auth_name', name);
        
        debugPrint('User created via Firebase');
        notifyListeners();
        return;
      } on FirebaseAuthException catch (e) {
        // If API key error, fall back to local mode
        final message = e.message ?? '';
        if (e.code.contains('api-key') || message.contains('api-key')) {
          debugPrint('Firebase not configured, using local authentication');
          _useFirebase = false;
          // Fall through to local authentication
        } else {
          // Other Firebase errors - rethrow
          String errorMessage = 'Signup failed';
          switch (e.code) {
            case 'weak-password':
              errorMessage = 'Password is too weak';
              break;
            case 'email-already-in-use':
              errorMessage = 'An account already exists for this email';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email address';
              break;
            case 'operation-not-allowed':
              errorMessage = 'Email/password accounts are not enabled';
              break;
            default:
              errorMessage = e.message ?? 'Signup failed';
          }
          throw Exception(errorMessage);
        }
      }
      
      // Fallback to local authentication
      final prefs = await SharedPreferences.getInstance();
      final existingEmail = prefs.getString('auth_email');
      if (existingEmail != null && existingEmail.toLowerCase() == email.trim().toLowerCase()) {
        throw Exception('An account with this email already exists');
      }
      
      // Save user credentials
      await prefs.setString('auth_email', email.trim());
      await prefs.setString('auth_password', password);
      await prefs.setString('auth_name', name);
      
      debugPrint('User saved locally - Email: ${email.trim()}, Name: $name');
      
      _email = email.trim();
      _isAuthenticated = true;
      debugPrint('User created via local authentication');
      notifyListeners();
    } catch (e) {
      debugPrint('Signup error: $e');
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      if (_useFirebase) {
        try {
          await _auth.signOut();
        } catch (e) {
          debugPrint('Firebase logout error (continuing with local logout): $e');
        }
      }
      
      // Clear session state but keep credentials for future login
      _user = null;
      _email = null;
      _isAuthenticated = false;
      
      // Don't remove saved credentials - they should persist for future logins
      // Only clear the current session
      
      debugPrint('User logged out successfully (credentials preserved for future login)');
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
      throw Exception('Logout failed');
    }
  }
  
  // Method to completely delete account (removes credentials)
  Future<void> deleteAccount() async {
    try {
      if (_useFirebase && _user != null) {
        try {
          await _user!.delete();
          await _auth.signOut();
        } catch (e) {
          debugPrint('Firebase account deletion error: $e');
        }
      }
      
      // Remove all saved credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_email');
      await prefs.remove('auth_password');
      await prefs.remove('auth_name');
      
      _user = null;
      _email = null;
      _isAuthenticated = false;
      
      debugPrint('Account deleted successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Account deletion error: $e');
      throw Exception('Account deletion failed');
    }
  }
}


