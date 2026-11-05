# flutter-kit-features/auth — How to Use

## What's Inside

Complete authentication feature with Clean Architecture:

```
auth/
├── lib/
│   ├── domain/
│   │   ├── entities/auth_entity.dart         ← AuthEntity with token, user Map, flags
│   │   ├── repositories/auth_repository.dart ← Abstract repository interface
│   │   └── usecases/
│   │       ├── auth_params/auth_request_params.dart ← All request param classes
│   │       └── login_usecase.dart            ← All use cases in one file
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── auth_endpoints.dart           ← API endpoint constants (TODO: change)
│   │   │   └── auth_remote_datasource.dart   ← All API calls
│   │   ├── models/auth_model.dart            ← AuthModel (fromJson, toEntity)
│   │   └── repositories/auth_repository_impl.dart
│   ├── presentation/cubit/
│   │   ├── auth_cubit.dart                   ← Full AuthCubit with all actions
│   │   └── auth_state.dart                   ← AuthState, AuthAction, AuthStatus enums
│   └── auth_injection.dart                   ← GetIt DI setup
└── HOW_TO_USE.md
```

## Setup

### 1. Copy these files from flutter-kit-core into your project first
```
lib/core/api_service/ (network.dart, api_handler.dart, api_response.dart, interceptor.dart)
lib/core/errors/ (exceptions.dart, failure.dart)
lib/core/services/storage_service.dart
lib/core/session/session_cubit.dart
lib/core/di/service_locator.dart
lib/core/usecase/usecase.dart
```

### 2. Copy auth feature files
Copy the entire `lib/` folder of this feature into your project, maintaining the path.

### 3. Configure endpoints
Edit `lib/data/datasources/auth_endpoints.dart` to match your backend routes.

### 4. Register in DI
In your `service_locator.dart` or `main.dart`:

```dart
import 'features/auth/auth_injection.dart';

void main() async {
  await setup(DevConfig());
  await initDependencies();
  initAuthInjection(); // Add this
  runApp(const MyApp());
}
```

### 5. With social login (Google/Apple)
```dart
initAuthInjection(
  socialTokenProvider: (method) async {
    if (method == 'google') {
      final user = await GoogleSignIn().signIn();
      final auth = await user?.authentication;
      return auth?.idToken;
    } else {
      // Apple sign-in
      final credential = await SignInWithApple.getAppleIDCredential(...);
      return credential.identityToken;
    }
  },
);
```

### 6. Provide AuthCubit to widget tree
```dart
BlocProvider(
  create: (_) => sl<AuthCubit>(),
  child: MyApp(),
)
```

---

## Usage in Screens

### Login
```dart
context.read<AuthCubit>().login(
  LoginRequestParams(
    email: _emailController.text,
    password: _passwordController.text,
  ),
);
```

### Listen for state changes
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state.isLoginSuccess) {
      context.go(Routes.main.path);
    }
    if (state.isErrorOf(AuthAction.login)) {
      CustomSnackBar.error(context, state.message ?? 'Login failed');
    }
  },
  child: ...
)
```

### Loading state
```dart
BlocSelector<AuthCubit, AuthState, bool>(
  selector: (s) => s.isLoginLoading,
  builder: (_, isLoading) => ButtonComponent.primary(
    text: 'Login',
    isLoading: isLoading,
    onPressed: () => _login(),
  ),
)
```

### Forgot password flow
```dart
// 1. Send OTP
cubit.forgotPassword(ForgotPasswordRequestParams(email: email));

// 2. Verify OTP
cubit.verifyOtp(VerifyOtpRequestParams(email: email, otp: otp, mode: 'forgot'));

// 3. Reset password (uses resetToken from storage)
final token = sl<StorageService>().getResetToken();
cubit.resetPassword(ResetPasswordRequestParams(password: newPwd, resetToken: token!));
```

---

## Backend Requirements

Your backend must implement these endpoints (customize in auth_endpoints.dart):

| Endpoint | Method | Body | Response |
|----------|--------|------|----------|
| `/auth/signin` | POST | `{email, password, method}` | `{token, user, isProfileCompleted, isEmailVerified}` |
| `/auth/signup` | POST | `{email, password, method}` | Same as above |
| `/auth/verify-otp` | POST | `{email, otp, mode?}` | `{token?, tempToken?, user?}` |
| `/auth/resend-otp` | POST | `{email}` | `{message}` |
| `/auth/forgot` | POST | `{email}` | `{message}` |
| `/auth/reset-password` | POST | `{password, resetToken}` | `{message}` |
| `/auth/change-password` | POST | `{password, newPassword}` | `{message}` |
| `/auth/logout` | POST | — | `{message}` |

All responses should follow:
```json
{ "success": true, "message": "...", "data": { ... } }
```
