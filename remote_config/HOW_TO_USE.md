# flutter-kit-features/remote_config — How to Use

## What's Inside

Generic Firebase Remote Config wrapper with typed key access:

```
remote_config/lib/
├── domain/
│   ├── entities/remote_config_entity.dart  ← Map<String,dynamic> + typed getters
│   └── repositories/remote_config_repository.dart
├── data/
│   ├── datasources/remote_config_datasource.dart  ← FirebaseRemoteConfig wrapper
│   ├── models/remote_config_model.dart
│   └── repositories/remote_config_repository_impl.dart
├── presentation/cubit/
│   ├── remote_config_cubit.dart
│   └── remote_config_state.dart
└── remote_config_injection.dart
```

**tailored's ConfigEntity (realisticAvatarGenerate, avatarGenerate, etc.) removed — those were app-specific keys. This kit returns all keys generically so YOUR app defines its own.**

---

## Setup

### 1. pubspec.yaml
```yaml
dependencies:
  firebase_remote_config: ^5.0.0
  firebase_core: ^3.0.0
  flutter_bloc: ^9.0.0
  get_it: ^8.0.0
  fpdart: ^1.1.0
```

### 2. Firebase setup
1. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Initialize Firebase in `main.dart`:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### 3. Set defaults in Firebase Console
In Firebase Console → Remote Config → Add parameters:
```
chatbot_message_limit   = 10
maintenance_mode        = false
app_version_required    = "1.0.0"
feature_chat_enabled    = true
```

### 4. Register in DI
```dart
import 'features/remote_config/remote_config_injection.dart';

initRemoteConfigInjection();
```

### 5. Fetch config at app start
```dart
// In main.dart or splash screen:
await sl<RemoteConfigCubit>().fetchConfig();
```

---

## Usage

### Access values anywhere via sl
```dart
final config = sl<RemoteConfigCubit>();

// Typed access with defaults
final limit = config.getInt('chatbot_message_limit', defaultValue: 10);
final isMaintenance = config.getBool('maintenance_mode', defaultValue: false);
final version = config.getString('app_version_required', defaultValue: '1.0.0');
final chatEnabled = config.getBool('feature_chat_enabled', defaultValue: true);
```

### React to config changes in UI
```dart
BlocBuilder<RemoteConfigCubit, RemoteConfigState>(
  builder: (context, state) {
    if (!state.config.getBool('feature_chat_enabled')) {
      return const FeatureDisabledWidget();
    }
    return const ChatScreen();
  },
)
```

### Provide at app root
```dart
BlocProvider.value(
  value: sl<RemoteConfigCubit>(),
  child: const MyApp(),
)
```

---

## Define Your Own Config Keys

Create a constants file in your project:

```dart
class ConfigKeys {
  static const String chatMessageLimit = 'chatbot_message_limit';
  static const String maintenanceMode = 'maintenance_mode';
  static const String featureChatEnabled = 'feature_chat_enabled';
  static const String requiredAppVersion = 'app_version_required';
}

// Usage:
sl<RemoteConfigCubit>().getBool(ConfigKeys.maintenanceMode)
```
