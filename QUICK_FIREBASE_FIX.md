# 🔥 QUICK FIX: Firebase API Key Error

## The Problem
You're seeing this error:
```
api-key-not-valid.-please-pass-a-valid-api-key
```

This means the Firebase configuration in `lib/firebase_options.dart` has placeholder values instead of your real Firebase project credentials.

## ✅ Quick Solution (Choose One)

### Option 1: Use FlutterFire CLI (Easiest - Recommended)

1. **Install FlutterFire CLI**:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Configure Firebase** (This will automatically update firebase_options.dart):
   ```bash
   flutterfire configure
   ```
   
   - Select your Firebase project
   - Select the platforms you want (at least: web, android)
   - It will automatically generate the correct `firebase_options.dart` file

4. **Restart the app**:
   ```bash
   flutter run -d chrome
   ```

### Option 2: Manual Configuration

1. **Go to Firebase Console**: https://console.firebase.google.com/

2. **Create or Select a Project**

3. **Add a Web App**:
   - Click "Add app" > Web icon
   - Register your app
   - Copy the Firebase configuration

4. **Update `lib/firebase_options.dart`**:
   - Open `lib/firebase_options.dart`
   - Replace the `web` section with your actual values:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'YOUR_ACTUAL_API_KEY',  // Replace this
     appId: 'YOUR_ACTUAL_APP_ID',     // Replace this
     messagingSenderId: 'YOUR_SENDER_ID',  // Replace this
     projectId: 'YOUR_PROJECT_ID',    // Replace this
     authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',  // Replace this
     storageBucket: 'YOUR_PROJECT_ID.appspot.com',   // Replace this
   );
   ```

5. **Enable Authentication**:
   - Go to Firebase Console > Authentication
   - Click "Get Started"
   - Enable "Email/Password" sign-in method
   - Click "Save"

6. **Create Firestore Database**:
   - Go to Firebase Console > Firestore Database
   - Click "Create database"
   - Choose "Start in test mode"
   - Select location and click "Enable"

7. **Restart the app**

## 🎯 After Configuration

Once you've configured Firebase:
- ✅ Signup will create users in Firebase Authentication
- ✅ User data will be saved to Firestore
- ✅ Login will authenticate via Firebase
- ✅ You can see users in Firebase Console

## 📝 Firestore Security Rules

After creating Firestore, update the security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## ❓ Still Having Issues?

1. Make sure you've enabled Email/Password authentication in Firebase Console
2. Verify your `firebase_options.dart` has real values (not placeholders)
3. Check the browser console for more detailed error messages
4. Restart the Flutter app after making changes


