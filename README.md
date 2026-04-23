# Mobile Application Design (MAD) - Next Level

A Flutter-based mobile application for event management with notifications, favorites, filtering, and map integration.

## Features

- 🗓️ Event Management - Create and view events
- ❤️ Favorites - Mark events as favorites
- 🔔 Notifications - Get notified about events
- 🗺️ Map Integration - View events on map
- 🔍 Filtering - Filter events by categories
- 👤 User Authentication - Sign up and login
- 🔐 Firebase Integration - Real-time data sync

## Requirements

- **Flutter SDK**: Version 3.0 or higher
- **Dart SDK**: Version 2.19 or higher
- **Android**: Android 5.0 or higher (API level 21+)
- **iOS**: iOS 11.0 or higher
- **Firebase Account**: For backend services
- **Git**: For version control

## Installation Process

### 1. Prerequisites

Ensure you have Flutter and Dart installed on your system:

```bash
# Check Flutter version
flutter --version

# Check Dart version
dart --version
```

If not installed, download from [flutter.dev](https://flutter.dev/docs/get-started/install)

### 2. Clone the Repository

```bash
git clone https://github.com/Khalid1419h/Mobile_Application_Design.git
cd MAD_Project_NEXTLEVEL
```

### 3. Install Dependencies

```bash
# Get all Flutter packages
flutter pub get

# Or use the shorter command
flutter packages get
```

### 4. Android Setup

```bash
# Navigate to Android folder
cd android

# Build the app (optional, for first run)
./gradlew build

# Return to project root
cd ..
```

### 5. iOS Setup (macOS only)

```bash
# Navigate to iOS folder
cd ios

# Install dependencies
pod install

# Return to project root
cd ..
```

### 6. Configure Firebase

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android and iOS apps to your Firebase project
3. Download `google-services.json` and place it in `android/app/`
4. Download `GoogleService-Info.plist` and place it in `ios/Runner/`
5. Update `firebase_options.dart` with your Firebase credentials

### 7. Run the Application

```bash
# Run on default device/emulator
flutter run

# Run on specific device
flutter devices              # List available devices
flutter run -d <device_id>

# Run with verbose logging
flutter run -v

# Run in release mode
flutter run --release
```

## Project Structure

```
lib/
├── main.dart                      # Entry point
├── firebase_options.dart          # Firebase configuration
├── models/
│   └── notification_model.dart    # Data models
├── screens/
│   ├── home_page.dart            # Home screen
│   ├── login_page.dart           # Login screen
│   ├── signup_page.dart          # Sign up screen
│   ├── add_event_page.dart       # Add event screen
│   ├── event_detail_page.dart    # Event details
│   ├── favorite_screen.dart      # Favorites screen
│   ├── filter_screen.dart        # Filter screen
│   ├── map_screen.dart           # Map view
│   ├── notification_screen.dart  # Notifications
│   └── profile_screen.dart       # User profile
├── services/
│   └── notification_service.dart # Notification logic
└── widgets/
    └── bottom_nav_bar.dart       # Navigation bar
```

## Available Commands

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Build APK (Android)
flutter build apk --release

# Build AAB (Android App Bundle)
flutter build appbundle --release

# Build IPA (iOS)
flutter build ios --release

# Clean build artifacts
flutter clean
```

## Troubleshooting

### Flutter not found
```bash
# Add Flutter to PATH environment variable
export PATH="$PATH:/path/to/flutter/bin"
```

### Dependencies conflict
```bash
# Clear pub cache
flutter pub cache clean
flutter pub get
```

### Build issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Dependencies

Key packages used in this project:
- `firebase_core` - Firebase initialization
- `firebase_auth` - Authentication
- `cloud_firestore` - Database
- `google_maps_flutter` - Map integration
- `flutter_local_notifications` - Local notifications

See `pubspec.yaml` for the complete list.

## License

This project is open source and available under the MIT License.

## Support

For issues, suggestions, or contributions, please open an issue on GitHub.

---

**Created**: April 2026  
**Repository**: [GitHub - Mobile Application Design](https://github.com/Khalid1419h/Mobile_Application_Design)
