# How to Deploy Firestore Security Rules

The permission error occurs because the Firestore security rules haven't been deployed to Firebase yet. Follow these steps:

## Option 1: Deploy via Firebase CLI (Recommended)

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Initialize Firebase in your project** (if not done already):
   ```bash
   firebase init firestore
   ```
   - Select your Firebase project
   - Use the existing `firestore.rules` file

4. **Deploy the rules**:
   ```bash
   firebase deploy --only firestore:rules
   ```

## Option 2: Manual Update in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Firestore Database** → **Rules** tab
4. Copy and paste the contents of `firestore.rules` file
5. Click **Publish**

## Option 3: Use Test Mode (Development Only - NOT for Production)

For quick testing during development, you can temporarily use test mode rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 12, 31);
    }
  }
}
```

**⚠️ WARNING**: Test mode allows anyone to read/write your database. Only use this for development and testing!

## Verify Rules Are Active

After deploying:
1. Try saving a profile again
2. Check Firebase Console → Firestore Database → Data tab
3. You should see your user document under `users/{email}`

## Troubleshooting

If you still get permission errors after deploying:
1. Make sure you're logged in: Check `FirebaseAuth.instance.currentUser` is not null
2. Verify your email matches: The document ID should be your email (lowercase)
3. Check the rules syntax: Use Firebase Console to validate the rules
4. Wait a few seconds: Rules can take a moment to propagate

