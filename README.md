# Sena – Unskilled Labour Hiring Platform

A **Flutter frontend** application connecting workers, contractors, and companies for unskilled labour hiring.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10+ installed → [flutter.dev/docs/get-started](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code with Flutter extension

### Running the App

```bash
# Install dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome

# Run on Android
flutter run -d android

# Run on Windows Desktop
flutter run -d windows
```

## 👥 User Roles & Demo Login

| Role | Demo Login |
|---|---|
| **Worker** | Select "Worker" → tap "Continue as Worker (Demo)" |
| **Contractor** | Select "Contractor" → tap "Continue as Contractor (Demo)" |
| **Company** | Select "Company" → tap "Continue as Company (Demo)" |

## 📱 Screen Map

### Auth
- Splash → Role Selection → Login / Register (per role)

### Company
- Dashboard → Browse Workers/Contractors → Create Hiring Request → Sent Requests

### Contractor
- Dashboard → Manage Workers → Add Worker → Incoming Requests (Accept/Reject)

### Worker
- Dashboard → My Profile → Incoming Requests (Accept/Reject)

## 🗂️ Project Structure

```
lib/
├── main.dart              # Entry point
├── core/
│   ├── models/            # Data models + mock data
│   ├── providers/         # Auth, Request, Worker providers
│   ├── router/            # go_router navigation
│   └── theme/             # App theme (colors, typography)
├── features/
│   ├── auth/              # Splash, RoleSelect, Login, Registration
│   ├── company/           # Company screens
│   ├── contractor/        # Contractor screens
│   └── worker/            # Worker screens
└── shared/
    ├── widgets/           # Reusable widgets
    └── screens/           # Notifications, RequestDetail
```

## 🛠️ Tech Stack
- **Flutter** 3.10+
- **go_router** — navigation
- **provider** — state management
- **google_fonts** (Inter) — typography
- **intl** — date formatting
- All data is mocked in-memory (ready for API swap-in)
