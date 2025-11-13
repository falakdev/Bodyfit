import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/models/user_profile.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Get current user email
  String? get currentUserEmail => _auth.currentUser?.email;

  // Get user document reference by email
  DocumentReference? _getUserDocByEmail(String email) {
    if (email.isEmpty) return null;
    // Normalize email to lowercase for consistent storage
    final normalizedEmail = email.toLowerCase().trim();
    return _firestore.collection('users').doc(normalizedEmail);
  }

  // Save user profile to Firestore (by email)
  Future<void> saveUserProfile(UserProfile profile) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated. Please log in first.');
    }
    
    final userEmail = user.email;
    if (userEmail == null || userEmail.isEmpty) {
      throw Exception('User email not available. Please ensure your account has an email.');
    }

    try {
      // Wait for auth token to be ready
      await user.getIdToken(true); // Force refresh token
      
      final userDoc = _getUserDocByEmail(userEmail);
      if (userDoc == null) {
        throw Exception('Could not create user document reference');
      }

      final profileData = profile.toMap();
      profileData['email'] = userEmail.toLowerCase().trim();
      profileData['userId'] = user.uid;
      profileData['lastUpdated'] = FieldValue.serverTimestamp();
      profileData.remove('id'); // Remove id from map as Firestore will use document ID

      // First, create/update the user document
      await userDoc.set({
        'email': userEmail.toLowerCase().trim(),
        'userId': user.uid,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Then save the profile subcollection
      await userDoc
          .collection('profile')
          .doc('data')
          .set(profileData, SetOptions(merge: true));
          
      debugPrint('Profile saved successfully for email: $userEmail');
    } catch (e) {
      final errorString = e.toString();
      debugPrint('Error saving user profile: $errorString');
      if (errorString.contains('permission-denied') || errorString.contains('PERMISSION_DENIED')) {
        throw Exception('Permission denied. Please deploy Firestore security rules to Firebase Console. See DEPLOY_FIRESTORE_RULES.md for instructions. Quick fix: Go to Firebase Console → Firestore Database → Rules → Paste the rules from firestore.rules → Publish');
      }
      rethrow;
    }
  }

  // Get user profile from Firestore (by email)
  Future<UserProfile?> getUserProfile() async {
    final userEmail = currentUserEmail;
    if (userEmail == null || userEmail.isEmpty) {
      debugPrint('No user email available');
      return null;
    }

    try {
      final userDoc = _getUserDocByEmail(userEmail);
      if (userDoc == null) {
        debugPrint('Could not get user document reference');
        return null;
      }

      final doc = await userDoc
          .collection('profile')
          .doc('data')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['id'] = doc.id;
        debugPrint('Profile loaded successfully for email: $userEmail');
        return UserProfile.fromMap(data);
      } else {
        debugPrint('No profile data found for email: $userEmail');
      }
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      // If permission error, try to create the document structure
      if (e.toString().contains('permission-denied')) {
        debugPrint('Permission denied - user may need to sign up first');
      }
    }
    return null;
  }

  // Update daily step goal
  Future<void> updateDailyGoal(int goal) async {
    final userEmail = currentUserEmail;
    if (userEmail == null || userEmail.isEmpty) {
      throw Exception('User not authenticated or email not available');
    }

    try {
      final userDoc = _getUserDocByEmail(userEmail);
      if (userDoc == null) {
        throw Exception('Could not create user document reference');
      }

      await userDoc
          .collection('profile')
          .doc('data')
          .update({
        'dailyStepGoal': goal,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating daily goal: $e');
      rethrow;
    }
  }

  // Save step data
  Future<void> saveStepData(int steps, double calories) async {
    final userEmail = currentUserEmail;
    if (userEmail == null || userEmail.isEmpty) return;

    try {
      final userDoc = _getUserDocByEmail(userEmail);
      if (userDoc == null) return;

      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await userDoc
          .collection('dailyStats')
          .doc(dateKey)
          .set({
        'steps': steps,
        'calories': calories,
        'date': dateKey,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving step data: $e');
    }
  }
  
  // Get user email for display
  String? getUserEmail() {
    return currentUserEmail;
  }
}

