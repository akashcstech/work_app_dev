# Raksha-Kavach — Worker Safety Auditor

A Flutter app that helps construction/industrial workers stay safe by completing daily PPE checklists, logging near-miss incidents, and taking safety quizzes.

## Features
- 🔐 Firebase Email/Password Auth
- ✅ Task-based PPE checklist with avatar gear visualization
- 📊 Risk meter (Low / Medium / High) based on unchecked gear
- 🗂️ Local SQLite incident log with score penalty
- 🧠 Daily safety quiz with score rewards
- 🔔 Daily 8 AM push notification reminder
- ☁️ Firestore score sync (optional, gracefully fails without config)

## Quick Start

```bash
cd raksha_kavach
flutter create .          # generates android/ ios/ wrappers
flutter pub get
flutter run
```

## Firebase Setup
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create a project → Add Android app (package: `com.example.raksha_kavach`)
3. Download `google-services.json` → place at `android/app/google-services.json`
4. Enable **Email/Password** auth + **Firestore**
5. Follow `ANDROID_MANIFEST_HINTS.txt` for manifest permissions

## Project Structure
```
lib/
├── main.dart
├── models/        task.dart, incident.dart
├── services/      auth_service, db_service, notification_service
├── providers/     checklist_provider, score_provider
├── screens/       splash, login, home, checklist, incident_log, quiz
└── widgets/       task_card, risk_meter, avatar_view
```
