# Flutter Chat App

Real-time chat application built with Flutter and Firebase.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

## Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter App   │    │    Firebase      │    │     Users       │
│                 │    │                  │    │                 │
│  ┌─────────────┐│    │ ┌──────────────┐ │    │ ┌─────────────┐ │
│  │Auth Screen  ││◄──►│ │Firebase Auth │ │    │ │   User A    │ │
│  └─────────────┘│    │ └──────────────┘ │    │ └─────────────┘ │
│                 │    │                  │    │        │        │
│  ┌─────────────┐│    │ ┌──────────────┐ │    │        ▼        │
│  │Chat Screen  ││◄──►│ │  Firestore   │ │◄──►│ ┌─────────────┐ │
│  └─────────────┘│    │ │  (Messages)  │ │    │ │   User B    │ │
│                 │    │ └──────────────┘ │    │ └─────────────┘ │
│  ┌─────────────┐│    │                  │    │        │        │
│  │Image Picker ││◄──►│ ┌──────────────┐ │    │        ▼        │
│  └─────────────┘│    │ │Firebase      │ │    │ ┌─────────────┐ │
│                 │    │ │Storage       │ │    │ │   User C    │ │
└─────────────────┘    │ │(Images)      │ │    │ └─────────────┘ │
                       │ └──────────────┘ │    └─────────────────┘
                       │                  │
                       │ ┌──────────────┐ │
                       │ │Firebase      │ │
                       │ │Messaging     │ │
                       │ │(Push Notifs) │ │
                       │ └──────────────┘ │
                       └──────────────────┘
```

## Features

- **Authentication**: User authentication with Firebase Auth
- **Real-time Messaging**: Instant message delivery with Cloud Firestore

## Screenshots

<div align="center">

| Create Account Screen                                                                                    | Auth and Chat Screen                                                                                      | Sign In Screen                                                                                           |
| -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| <img width="250" src="https://github.com/user-attachments/assets/057e425c-d1d5-4bc9-b788-e419bf27b036" > | <img width="250" src="https://github.com/user-attachments/assets/c1d4833f-ad86-45d6-a054-6cf125442be8" /> | <img width="250" src="https://github.com/user-attachments/assets/ac70a37c-49f6-4bb4-b5db-d11887d0ba95" > |

</div>

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yohanangulo/flutter-chat-app.git
cd flutter-chat-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication, Firestore Database, Storage, and Messaging
3. Add your platform-specific configuration files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 4. Run the Application

```bash
# For mobile development
flutter run
```

## Project Structure

```
lib/
├── auth/
│   └── presentation/
│       └── auth_screen.dart          # Authentication UI
├── chat/
│   └── presentation/
│       ├── chat_screen.dart          # Main chat interface
│       └── widgets/
│           ├── chats_messages.dart   # Message list display
│           ├── message_bubble.dart   # Individual message UI
│           └── new_message.dart      # Message input widget
├── core/
│   ├── extensions/                   # Dart extensions
│   └── presentation/
│       ├── app/                      # App configuration
│       ├── theme/                    # UI theming
│       └── widgets/                  # Reusable widgets
├── splash/
│   └── presentation/
│       └── splash_screen.dart        # Loading screen
├── firebase_options.dart             # Firebase configuration
└── main.dart                         # App entry point
```

---

**Built with Flutter | Developed by Yohan Angulo**
