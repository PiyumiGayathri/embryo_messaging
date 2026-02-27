# SLT Digital Lab – Device Configurator

A Flutter mobile application that allows users to configure a device profile and send the configuration as a pre-filled SMS to up to **5 recipients** using the device's native messaging app.

---

## Screenshots

<img width="1080" height="1920" alt="Screenshot_20260228_004340" src="https://github.com/user-attachments/assets/0cdbc484-5e58-4780-bf89-1349b61b0353" />

<img width="1080" height="1920" alt="Screenshot_20260228_004240" src="https://github.com/user-attachments/assets/eadd5770-14c8-48a9-9edc-45d2ce1deef3" />


---

## Features

-  Configure device name, location, and SMS interval
-  Add up to **5 SMS recipients** (comma-separated)
-  Set separate **Emergency Alert Recipients**
-  Toggle and name **5 individual lines** (ON/OFF)
-  Opens the **native SMS app** pre-filled with the full configuration message
-  Multi-recipient support — send to one or all recipients
-  **Persists configuration** locally using `shared_preferences`
-  Form validation for all required fields

---

## Tech Stack

 [Flutter](https://flutter.dev/) - Cross-platform UI framework 
 [Dart](https://dart.dev/) - Programming language 
 [`url_launcher`](https://pub.dev/packages/url_launcher) - Opens native SMS app with pre-filled content |
 [`shared_preferences`](https://pub.dev/packages/shared_preferences) - Local persistence of form data |

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.10.7`
- Dart SDK `^3.10.7`
- Android Studio / VS Code with Flutter plugin
- A physical Android or iOS device (recommended for SMS testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/embryo.git
   cd embryo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## Configuration

### `pubspec.yaml` Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  url_launcher: ^6.3.0
  shared_preferences: ^2.3.0
```

### Android Setup

Add the following to `android/app/src/main/AndroidManifest.xml` inside the `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.SEND_SMS"/>
<queries>
  <intent>
    <action android:name="android.intent.action.SENDTO"/>
    <data android:scheme="smsto"/>
  </intent>
</queries>
```

### iOS Setup

Add the following to `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>sms</string>
</array>
```

---

## How It Works

1. **Fill in the form** — Enter device name, location, recipients, SMS interval, and configure up to 5 lines with toggle and optional name.
2. **Tap "Save Configuration"** — The app validates the form and saves data locally.
3. **SMS opens automatically** — The native SMS app opens with the recipient number and a pre-filled message body.
4. **Multiple recipients** — A bottom sheet lets you send to a specific recipient or all of them one by one.
5. **User taps Send** — The message is delivered to the recipient's native messaging app.

### Example SMS Message

```
SLT Digital Lab - Device Configuration
Device: test 8
Location: bemmulla
SMS Interval: 1 hr(s)
---
lotus road line: ON
Line 2: OFF
Line 3: ON
Line 4: ON
Line 5: ON
```

---

## Project Structure

```
embryo/
├── android/                  # Android native project
├── ios/                      # iOS native project
├── lib/
│   └── main.dart             # Main app entry point & all UI logic
├── test/
│   └── widget_test.dart      # Widget tests
├── pubspec.yaml              # Project dependencies
└── README.md
```

---

## Platform Support

 Android - Yes 
 iOS -  Yes 
 Web -  No (SMS not supported) 
 Windows / macOS / Linux -  No (SMS not supported) 

---

## Permissions

This app uses `url_launcher` to open the **system SMS app** — it does **not** send SMS silently in the background. The user always reviews and manually taps **Send** in their native messaging app. No special dangerous permissions are required.

---

## Running Tests

```bash
flutter test
```

---

## Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a Pull Request

---

## Author

**Piyumi Prmachandra**  
GitHub: [@PiyumiGayathri](https://github.com/PiyumiGayathri)

---

>  **Note:** SMS functionality requires a physical device. Emulators/simulators may not support opening the native SMS app.
