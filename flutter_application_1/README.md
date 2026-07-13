```markdown
# LaunchPad ALU

A Flutter + Firebase mobile marketplace connecting ALU students with internship and opportunity listings from verified, student-led startups at ALU.

## 📱 Overview

LaunchPad ALU is a two-sided platform:
- **Startups** register, get verified, and post internship/opportunity listings
- **Students** discover opportunities, search/filter them, and apply directly through the app
- All data updates in real time via Firebase Firestore

## 🚀 Features

### Student Side
- Sign up / log in with email & password
- Browse and search a live feed of open opportunities
- View full opportunity details
- Apply to opportunities (with duplicate-application prevention)
- Track all submitted applications and their status (pending / accepted / rejected)

### Startup Side
- Sign up / log in with a dedicated Startup role
- Startup verification system (`isVerified` flag — only verified ALU startups appear to students)
- Post, view, and manage opportunity listings
- View and manage applicants per opportunity
- Update application status in real time
- Edit startup profile (name, description, category)

### Technical
- Firebase Authentication (email/password)
- Cloud Firestore for real-time data (streams via `StreamBuilder`)
- Role-based navigation and access (Student vs Startup)
- Clean, denormalized Firestore schema for fast reads

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| Backend | Firebase (Authentication, Cloud Firestore) |
| State Management | Provider |
| Local Dev/Testing | Firebase Local Emulator Suite |

## 📂 Project Structure

```
lib/
  main.dart
  firebase_options.dart
  models/
    app_user.dart
    startup.dart
    opportunity.dart
    application.dart
  services/
    auth_service.dart
    firestore_service.dart
  screens/
    splash_screen.dart
    auth/
      login_screen.dart
      signup_screen.dart
    student/
      student_shell.dart
      student_home_screen.dart
      opportunity_detail_screen.dart
      my_applications_screen.dart
    startup/
      startup_shell.dart
      startup_home_screen.dart
      post_opportunity_screen.dart
      applicants_screen.dart
      startup_profile_screen.dart
  widgets/
    opportunity_card.dart
    app_button.dart
    empty_state.dart
```

## 🗄️ Firestore Data Model

```
users/{uid}
  - uid, email, role ("student" | "startup"), name, createdAt

startups/{startupId}         // startupId == owner's uid
  - ownerUid, name, description, category, isVerified, createdAt

opportunities/{opportunityId}
  - startupId, startupName, title, description, category,
    location, createdAt, isOpen

applications/{applicationId}
  - opportunityId, opportunityTitle, studentUid, studentName,
    startupId, status ("pending" | "accepted" | "rejected"), appliedAt
```

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK installed
- A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com)
- Node.js and Java installed (required for Firebase Local Emulator Suite)
- Firebase CLI: `npm install -g firebase-tools`

### 1. Clone the repository
```bash
git clone https://github.com/arnoldmutara/launchpad_alu.git
cd launchpad_alu
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Connect Firebase
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
Select your Firebase project and target platform(s) when prompted. This generates `lib/firebase_options.dart`.

### 4. Start the Firebase Emulators
```bash
firebase emulators:start
```
This runs Authentication and Firestore emulators locally. Leave this running in its own terminal while developing.

- Emulator UI: `http://127.0.0.1:4000`
- Auth emulator: port `9099`
- Firestore emulator: port `8080`

### 5. Run the app
```bash
flutter run
```
Select your target device (Android emulator, physical device, or Chrome for quick testing).

## 🔐 Enabling Startup Verification (for testing)

Since verification is manual for this project:
1. Open the Firestore Emulator UI at `http://127.0.0.1:4000/firestore`
2. Navigate to the `startups` collection
3. Find the relevant startup document
4. Manually set `isVerified` to `true`

## 🧪 Testing the Full Flow

1. Sign up as a **Startup** → post an opportunity
2. Flip `isVerified` to `true` in the emulator (see above)
3. Sign up as a **Student** (new account/browser session) → browse the Discover feed → apply to the opportunity
4. Log back in as the Startup → view the applicant → update their status
5. Log back in as the Student → confirm the application status updated in real time

## 📌 Known Limitations / Future Work

- Firestore security rules are currently open (test mode) — production deployment would require locking these down per user role
- Startup verification is manual; a future version could include an admin review dashboard
- No push notifications, messaging, or bookmarking yet (potential future features)
- Currently tested primarily on Android emulator / Chrome (update based on final testing device)

## 👤 Author

Arnold Mutara — ALU Software Engineering
```