# Agent Instructions

This repository is a Flutter app for Firebase-backed eCode verification. Start from [README.md](README.md) and [pubspec.yaml](ecode%20verifier/pubspec.yaml) when you need project context, dependencies, or setup details.

## Working Norms

- Treat [lib/main.dart](ecode%20verifier/lib/main.dart) as the app entrypoint: Firebase is initialized there before `AuthenticationRepository` is registered and the app boots into `SplashScreen`.
- Prefer the existing feature-first layout under [lib/src](ecode%20verifier/lib/src); follow nearby code patterns instead of introducing new architecture.
- Use GetX conventions already present in the app for state, navigation, and dependency injection.
- Keep Firebase-generated files such as [lib/firebase_options.dart](ecode%20verifier/lib/firebase_options.dart) and platform-specific service config files in sync with Firebase setup, but do not hand-edit generated values unless you are intentionally regenerating them.
- Keep asset references aligned with the `assets:` list in [pubspec.yaml](ecode%20verifier/pubspec.yaml).

## Useful Commands

- `flutter pub get` to install dependencies.
- `flutter run` to launch the app.
- `flutter test` for tests.
- `flutter analyze` for static analysis.

## Project Notes

- The app uses Firebase Auth, Cloud Firestore, GetX, Dio, and barcode scanning packages.
- Firebase support in [lib/firebase_options.dart](ecode%20verifier/lib/firebase_options.dart) is configured for web, Android, iOS, and macOS; Windows and Linux are not Firebase-ready here.
- The README structure section is older than the current `lib/src` layout, so prefer the source tree over that overview when navigating the codebase.