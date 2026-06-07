# 📱 Szabist Forums App

A university forums application built with Flutter as part of the Mobile Application Development (MAD) course — Assignment #2.

---

## 👥 Group Members

| Name | Roll Number |
|------|-------------|
| Sibtain Ahmed | 2380252 |
| Abdul Rafay | 2380220 |
| Syed Ali Imran | 2380254 |
| Mehmood Rashid | 2380237 |

---

## 📌 Assignment Overview

The goal of this assignment was to build a fully functional forums application that demonstrates modular app architecture using BLoC pattern, Firebase Authentication with Email/Password, Firebase Firestore as a real-time database, a separate local Flutter package for Firebase services, and Mockito unit tests for Firebase implementation.

---

## ✨ Features

- User Authentication — Register and login with email and password
- Create Topics — Authenticated users can start new forum topics
- Reply to Topics — Users can add replies to any forum topic
- Author Info — Every post and reply shows the author's name
- Timestamps — All posts display the date and time they were created
- Loaders — Loading indicators shown while fetching or posting data
- Validation — All forms have input validation and error handling
- Error Handling — User-friendly error messages via SnackBars

---

## 🛠️ Tech Stack

Flutter, Dart, Firebase Authentication, Cloud Firestore, flutter_bloc, firebase_services (local package), Mockito, FlutterFire CLI

---

## 🧠 BLoC Architecture

The app uses three separate BLoCs — AuthBloc handles sign in, sign up, and sign out. TopicsBloc handles loading and creating forum topics. RepliesBloc handles loading and adding replies to topics. Each BLoC communicates with Firebase through the firebase_services local package, keeping concerns separated and the codebase modular.

---

## 📦 Local Package — firebase_services

Located at packages/firebase_services/, this is a standalone Flutter package that encapsulates all Firebase logic. AuthService wraps FirebaseAuth for sign in, sign up, and sign out. ForumService wraps FirebaseFirestore for topics and replies CRUD operations. This design makes the Firebase layer independently testable and reusable.

---

## 🧪 Unit Tests with Mockito

Tests are located in packages/firebase_services/test/auth_service_test.dart. Mockito is used to stub FirebaseAuth so tests run without a real Firebase connection. Tests cover signIn, signUp, and signOut methods.

---

## 📚 Learning Outcomes

Writing modular Flutter apps with BLoC pattern, using Firebase for real-time database and authentication, creating and consuming local Flutter packages, and writing unit tests with Mockito stubs.

---

## 🔗 References

- BLoC Library: https://bloclibrary.dev
- Firebase Flutter Setup: https://firebase.google.com/codelabs/firebase-get-to-know-flutter
- FlutterFire Documentation: https://firebase.flutter.dev
- Mockito for Dart: https://pub.dev/packages/mockito
