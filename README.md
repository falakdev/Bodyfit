Here’s a **professional and polished `README.md`** for your **BodyFit** Flutter app — formatted with clear sections, badges, and developer-focused tone. You can copy this directly into your project root as `README.md` 👇

---

# 🏋️‍♂️ BodyFit

**Track your steps, burn calories, and build your fitness routine with an elegant cross-platform app that syncs your progress to the cloud.**

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue.svg?style=for-the-badge\&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-orange.svg?style=for-the-badge\&logo=firebase)
![Dart](https://img.shields.io/badge/Dart-Language-blue.svg?style=for-the-badge\&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

---

## 📱 Overview

**BodyFit** is a modern, cross-platform fitness tracking app built with **Flutter**. It helps users monitor their **daily steps, calories, and workouts**, while offering **cloud sync via Firebase** and **offline fallback** for seamless usage.

### ✨ Key Goals

* Make step tracking and progress **visual, simple, and actionable**
* Sync user data across devices using **Firebase Firestore**
* Deliver a **responsive and beautiful UI** with light/dark themes
* Support **offline use** with local persistence

---

## 🚀 Features

| Category              | Description                                                                            |
| --------------------- | -------------------------------------------------------------------------------------- |
| **Authentication**    | Email/password login using Firebase Auth with local SharedPreferences fallback         |
| **User Profiles**     | Create and edit profile (name, age, gender, weight, height, fitness level, daily goal) |
| **Step Tracking**     | Real-time pedometer on mobile (stubbed on web)                                         |
| **Progress Tracking** | Visual progress circles, calories, and weekly summaries                                |
| **Offline Mode**      | Local fallback for when Firebase is unavailable                                        |
| **Statistics**        | Daily goals, achievements, weekly charts                                               |
| **Workouts**          | Quick actions and history scaffolding                                                  |
| **Theming**           | Light and dark themes powered by `ThemeProvider`                                       |
| **Onboarding Flow**   | First-time user setup experience                                                       |
| **Cross-Platform**    | Fully responsive UI for Android, iOS, and Web                                          |

---

## 🧱 Architecture Overview

**Tech Stack:**

* **Flutter (Dart)** — UI & logic
* **Firebase** — Authentication + Firestore
* **SharedPreferences** — Local persistence
* **Provider** — State management

**Layered Architecture:**

```
lib/
├── core/
│   ├── models/
│   ├── theme/
│   ├── colors/
│   └── styles/
├── logic/
│   ├── auth_provider.dart
│   ├── step_provider.dart
│   └── theme_provider.dart
├── services/
│   └── firebase_service.dart
├── screens/
│   ├── auth/
│   ├── home/
│   ├── stats/
│   ├── profile/
│   └── workouts/
├── widgets/
│   └── progress_circle.dart
└── main.dart
```

---

## 🔥 Firebase Integration

### Services Used

* **Authentication** → Email/Password
* **Firestore** → User profiles, daily stats, diagnostics

### Firestore Structure

```
users/{email}/profile/data
users/{email}/dailyStats/{YYYY-MM-DD}
diagnostics/smoke_test
```

> ✅ Recommended Migration: use `users/{uid}` instead of `users/{email}` for improved security and flexibility.

---

## 🧩 Data Models

**UserProfile**

```dart
{
  id: string,
  name: string,
  age: int,
  weight: double,
  height: double,
  gender: string,
  fitnessLevel: string,
  dailyStepGoal: int,
  createdAt: Timestamp,
  lastUpdated: Timestamp
}
```

Computed property: **BMI** (derived from height and weight)

---

## ⚙️ Setup & Installation

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Firebase CLI](https://firebase.google.com/docs/cli)
* [FlutterFire CLI](https://firebase.flutter.dev/)
* Git

### Installation Steps

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/bodyfit.git
cd bodyfit

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase
dart pub global activate flutterfire_cli
firebase login
flutterfire configure

# 4. Run the app
flutter run -d android   # or chrome / ios
```

---

## 🔐 Firestore Rules

### Recommended Secure Rules (UID-based)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /diagnostics/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Current Setup (Email-based)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userEmail} {
      allow read, write: if request.auth != null &&
        request.auth.token.email != null &&
        request.auth.token.email.toLowerCase() == userEmail;
    }
  }
}
```

> ⚠️ Avoid permissive rules in production.
> Deploy rules with:

```bash
firebase deploy --only firestore:rules
```

---

## 🧠 Core Providers

### `AuthProvider`

* `login(email, password)`
* `signup(name, email, password)`
* `tryAutoLogin()`
* `logout()`
* `deleteAccount()`

### `StepProvider`

* Tracks steps, goals, and calories
* Syncs with Firebase or local cache
* `_initPedometer()` subscribes to step streams

### `FirebaseService`

* Handles Firestore read/write operations
* Saves and retrieves user profile & stats

---

## 💡 Development Notes

* **Offline Mode:** Uses `SharedPreferences` as fallback when Firebase is unavailable.
* **Themes:** Light and dark themes implemented via `ThemeProvider`.
* **Security:** Sensitive files (e.g., `google-services.json`, `firebase_options.dart`) should **not** be pushed to Git.

```bash
# Exclude sensitive files
git rm --cached lib/firebase_options.dart android/app/google-services.json
echo "lib/firebase_options.dart" >> .gitignore
echo "android/app/google-services.json" >> .gitignore
git add .gitignore
git commit -m "chore: ignore firebase config"
git push origin main
```

---

## 🧑‍💻 Contributing

Contributions are welcome!

1. Fork the repo
2. Create a new branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m "add feature"`
4. Push and create a Pull Request

---

## 📸 Screenshots

> *(Add screenshots of home screen, profile, and stats views here)*

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

### ❤️ BodyFit — Stay Active, Stay Fit, Stay Synced.

---

