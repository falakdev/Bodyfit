# Firebase Setup Instructions

## Important: Configure Your Firebase Project

The `lib/firebase_options.dart` file currently contains **placeholder values**. You need to replace them with your actual Firebase project credentials.

## Steps to Configure Firebase:

### Option 1: Using FlutterFire CLI (Recommended)

1. **Install FlutterFire CLI** (if not already installed):
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Configure Firebase for your project**:
   ```bash
   flutterfire configure
   ```
   
   This will:
   - Detect your platforms (Android, iOS, Web, etc.)
   - Connect to your Firebase project
   - Generate `lib/firebase_options.dart` with your actual credentials
   - Download configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS)

### Option 2: Manual Configuration

1. **Create a Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project"
   - Follow the setup wizard

2. **Add your app to Firebase**:
   - For Android: Add Android app with package name `com.example.bodyfit`
   - For iOS: Add iOS app with bundle ID `com.example.bodyfit`
   - For Web: Add Web app

3. **Download configuration files**:
   - Android: Download `google-services.json` and place it in `android/app/`
   - iOS: Download `GoogleService-Info.plist` and place it in `ios/Runner/`

4. **Update `lib/firebase_options.dart`**:
   - Replace the placeholder values with your actual Firebase project credentials
   - You can find these in Firebase Console > Project Settings > Your apps

## Enable Authentication in Firebase Console

1. Go to Firebase Console > Authentication
2. Click "Get Started"
3. Enable "Email/Password" authentication method
4. Click "Save"

## Set Up Firestore Database

1. Go to Firebase Console > Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select your preferred location
5. Click "Enable"

### Firestore Security Rules (Important!)

Update your Firestore security rules to allow authenticated users to read/write their own data. The app uses email-based document IDs for user data:

**Option 1: Use the provided firestore.rules file**
- A `firestore.rules` file is included in the project root
- Deploy it using: `firebase deploy --only firestore:rules`

**Option 2: Manually update in Firebase Console**

Go to Firebase Console > Firestore Database > Rules and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - documents are keyed by email (normalized to lowercase)
    match /users/{userEmail} {
      // Allow read/write if authenticated and email matches
      allow read, write: if request.auth != null && 
        request.auth.token.email != null &&
        request.auth.token.email.toLowerCase() == userEmail;
      
      // Users can read/write their own profile subcollection
      match /profile/{document=**} {
        allow read, write: if request.auth != null && 
          request.auth.token.email != null &&
          request.auth.token.email.toLowerCase() == userEmail;
      }
      
      // Users can read/write their own daily stats
      match /dailyStats/{document=**} {
        allow read, write: if request.auth != null && 
          request.auth.token.email != null &&
          request.auth.token.email.toLowerCase() == userEmail;
      }
    }
  }
}
```

**Note**: The app stores user data by email (normalized to lowercase) instead of UID for easier access and management.

## Verify Setup

After configuration, when you:
- **Sign up**: User will be created in Firebase Authentication AND saved to Firestore `users` collection
- **Login**: User will authenticate via Firebase Authentication
- **View Firebase Console**: You should see:
  - Users in Authentication > Users tab
  - User documents in Firestore > users collection

## Troubleshooting

If you see errors:
1. Make sure `firebase_options.dart` has your actual project credentials
2. Verify `google-services.json` is in `android/app/` (for Android)
3. Verify `GoogleService-Info.plist` is in `ios/Runner/` (for iOS)
4. Check that Email/Password authentication is enabled in Firebase Console
5. Ensure Firestore is created and security rules are set


