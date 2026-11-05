# flutter-kit-features/auth_user — How to Use

## What's Inside

Combined Auth + User profile feature:

```
auth_user/lib/
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart        ← Generic user (id, name, email, photo, location, etc.)
│   │   ├── location_data.dart      ← Self-contained lat/lng + address (no tailored widget)
│   │   └── check_username_response_entity.dart
│   ├── repositories/
│   │   └── user_repository.dart    ← Abstract interface
│   └── usecases/
│       ├── user_params.dart        ← Update profile params
│       ├── report_user_params.dart
│       └── user_usecases.dart      ← All 7 use cases
├── data/
│   ├── datasources/
│   │   ├── user_endpoints.dart     ← API paths (TODO: customize)
│   │   └── user_remote_datasource.dart
│   ├── models/
│   │   ├── user_model.dart         ← Flexible fromJson (10+ field name variants)
│   │   └── check_username_response_model.dart
│   └── repositories/
│       └── user_repository_impl.dart
├── presentation/cubit/
│   ├── user_cubit.dart
│   └── user_state.dart
└── auth_user_injection.dart
```

**Auth files are in `flutter-kit-features/auth/` — use both features together.**

---

## Setup

### 1. pubspec.yaml
```yaml
dependencies:
  flutter_bloc: ^9.0.0
  get_it: ^8.0.0
  fpdart: ^1.1.0
  dio: ^5.0.0
```

### 2. Configure endpoints
Edit `lib/data/datasources/user_endpoints.dart`:
```dart
static const String profile = '/users/me';
static const String updateProfile = '/users/me';
static const String checkUsername = '/users/check-username';
```

### 3. Register in DI
```dart
import 'features/auth_user/auth_user_injection.dart';
import 'features/auth/auth_injection.dart';

// In initDependencies():
initAuthInjection();       // Auth: login, signup, OTP, etc.
initUserInjection();       // User: profile, settings, block/report
```

### 4. Provide cubit
```dart
BlocProvider(
  create: (_) => sl<UserCubit>()..getProfile(),
  child: ProfileScreen(),
)
```

---

## Usage

### Get profile
```dart
context.read<UserCubit>().getProfile();

BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    if (state.isLoadingOf(UserAction.getProfile)) return const AppLoader();
    final user = state.user;
    return Text(user?.fullName ?? '');
  },
)
```

### Update profile
```dart
context.read<UserCubit>().updateProfile(UserParams(
  name: 'John Doe',
  username: 'johndoe',
  profilePicturePath: '/path/to/photo.jpg',  // null = no change
  location: LocationData(latitude: 37.7749, longitude: -122.4194, city: 'San Francisco'),
));
```

### Check username availability
```dart
context.read<UserCubit>().checkUsernameAvailability('johndoe');

// In listener:
if (state.action == UserAction.checkUsername && state.status == UserStatus.success) {
  final available = state.usernameAvailable ?? false;
}
```

### Delete account
```dart
AppDialog.delete(
  title: 'Delete Account',
  onConfirm: () => context.read<UserCubit>().deleteAccount(passwordController.text),
);
```

### Toggle notification
```dart
context.read<UserCubit>().updateNotification(isEnabled);
```

---

## Tailored Fields Removed

| Removed | Reason |
|---------|--------|
| `coinBalance` | Tailored coin economy |
| `isRealisticUnlocked` | Tailored avatar feature |
| `isSuggestionOpen` / `getSuggestions` | Tailored wardrobe suggestions |
| `AddressDetails` import | Was from tailored widget — replaced with `LocationData` |

---

## Backend Requirements

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/users/me` | GET | Returns current user profile |
| `/users/me` | PATCH | Updates profile (multipart, supports `image` file field) |
| `/users/check-username` | GET | Query `?username=` → `{isAvailable: bool}` |
| `/users/blocked` | GET | Returns list of blocked users |
| `/users/blocked` | POST | Body: `{userId, toggle}` |
| `/users/report` | POST | Body: `{userId, reason}` |
| `/users/me` | DELETE | Body: `{password}` — deletes account |
| `/users/notification-settings` | PATCH | Body: `{notification: bool}` |
