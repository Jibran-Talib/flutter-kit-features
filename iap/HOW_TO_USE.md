# flutter-kit-features/iap — How to Use

## What's Inside

Complete In-App Purchase (IAP) feature with Clean Architecture:

```
iap/
├── lib/
│   ├── constants.dart                            ← Product IDs (TODO: set yours)
│   ├── iap_endpoints.dart                        ← Backend API endpoints
│   ├── domain/
│   │   ├── entities/ (InAppProductEntity, StorePlanEntity, InAppPurchaseUpdateEntity)
│   │   ├── enums/in_app_purchase_status.dart
│   │   ├── repositories/in_app_purchase_repository.dart
│   │   └── usecases/ (all use cases + verify params)
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── in_app_purchase_store_datasource.dart ← Store (Apple/Google) calls
│   │   │   └── in_app_purchase_remote_datasource.dart ← Backend API calls
│   │   ├── models/ (InAppProductModel, InAppPurchaseUpdateModel, StorePlanModel)
│   │   ├── store_mapper/store_data_transformer.dart
│   │   └── repositories/in_app_purchase_repository_impl.dart
│   ├── presentation/cubit/
│   │   ├── in_app_purchase_cubit.dart
│   │   └── in_app_purchase_state.dart
│   └── iap_injection.dart
└── HOW_TO_USE.md
```

---

## Setup

### 1. pubspec.yaml
```yaml
dependencies:
  in_app_purchase: ^3.0.0
  flutter_bloc: ^9.0.0
  get_it: ^8.0.0
  fpdart: ^1.1.0
```

### 2. Configure your product IDs
Edit `lib/constants.dart`:
```dart
static const Set<String> productIds = {
  'premium_monthly',
  'premium_annual',
  'premium_lifetime',
};

static const Set<String> nonConsumableProductIds = {
  'premium_lifetime',  // bought once, never expires
};
```

### 3. Configure your package name
Edit `lib/domain/usecases/verify_in_app_purchase_params.dart`:
```dart
'packageName': 'com.yourcompany.yourapp',  // Android package name
```

### 4. Configure endpoints
Edit `lib/iap_endpoints.dart` to match your backend.

### 5. Register in DI
```dart
import 'features/iap/iap_injection.dart';

initIapInjection(
  onPurchaseSuccess: (productId) {
    // Called after backend verification succeeds.
    // Unlock premium, refresh user data, navigate to success screen, etc.
    sl<UserCubit>().refreshUser();
    // or:
    sl<SessionCubit>().updateUser({'isPremium': true});
  },
);
```

### 6. Provide cubit to widget tree
```dart
BlocProvider(
  create: (_) => sl<InAppPurchaseCubit>()..loadPlans(),
  child: ShopScreen(),
)
```

---

## App Store / Google Play Setup

### iOS (App Store Connect)
1. Create In-App Purchase products in App Store Connect
2. Use the product IDs exactly as defined in `constants.dart`
3. Add `StoreKit` capability in Xcode

### Android (Google Play Console)
1. Create In-App Products in Google Play Console
2. Use the product IDs exactly as defined in `constants.dart`
3. The app must be published (at least internal testing) for purchases to work

---

## Usage in Screens

### Load products
```dart
// In BlocBuilder
BlocBuilder<InAppPurchaseCubit, InAppPurchaseState>(
  builder: (context, state) {
    if (state.status == InAppPurchaseViewStatus.loading) return const AppLoader();
    return ListView.builder(
      itemCount: state.products.length,
      itemBuilder: (_, i) => PlanCard(plan: state.products[i]),
    );
  },
)
```

### Buy a product
```dart
context.read<InAppPurchaseCubit>().buyProduct(
  plan.toInAppProduct(),
);
```

### Listen for purchase result
```dart
BlocListener<InAppPurchaseCubit, InAppPurchaseState>(
  listener: (context, state) {
    if (state.purchaseStatus == InAppPurchaseActionStatus.success) {
      CustomSnackBar.success(context, 'Purchase successful!');
      context.go(Routes.main.path);
    }
    if (state.purchaseStatus == InAppPurchaseActionStatus.failure) {
      CustomSnackBar.error(context, state.message ?? 'Purchase failed');
    }
    if (state.purchaseStatus == InAppPurchaseActionStatus.canceled) {
      CustomSnackBar.error(context, 'Purchase canceled');
    }
  },
  child: ...
)
```

### Restore purchases
```dart
context.read<InAppPurchaseCubit>().restorePurchases();
```

---

## Backend Requirements

Your backend needs these endpoints:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `GET /iap/plans` | GET | Returns list of active plans from your DB |
| `POST /iap/verify` | POST | Verifies purchase receipt with Apple/Google |

### `/iap/plans` response format
```json
[
  {
    "_id": "...",
    "key": "premium_monthly",
    "label": "Monthly Premium",
    "description": "Full access for 1 month",
    "price": 9.99,
    "currency": "USD",
    "skuApple": "premium_monthly",
    "skuGoogle": "premium_monthly",
    "isActive": true
  }
]
```

### `/iap/verify` request body
```json
{
  "platform": "apple",          // or "google"
  "productId": "premium_monthly",
  "transactionId": "...",        // iOS: purchaseID
  // Android only:
  "purchaseToken": "...",
  "packageName": "com.yourapp"
}
```

### Backend Verification Logic
- **iOS**: Verify with Apple using the `transactionId` via StoreKit API or server-to-server
- **Android**: Verify with Google using `purchaseToken` via Google Play Developer API
- After verification, mark user as premium in your DB

See: https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/validating_receipts_with_the_app_store
See: https://developer.android.com/google/play/billing/security
