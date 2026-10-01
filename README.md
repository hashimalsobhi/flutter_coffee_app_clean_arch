# ☕ Flutter Specialty Coffee Lounge Mobile App (Clean Architecture)

A complete, production-grade, highly stylized **Specialty Coffee Shop & Lounge Mobile Application** built from scratch in **Flutter** adhering to strict **Clean Architecture** principles.

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-8A2BE2)](#clean-architecture-layer-breakdown)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

## 📸 Key Features & 6 Distinct Screens

1. **Splash & Welcome Onboarding Screen (`/`)**:
   - Warm espresso branding with velvet gradient overlays.
   - Tagline, brand badge, and quick entry into the specialty menu.

2. **Home & Coffee Menu Screen (`/home`)**:
   - Location header & VIP Gold member badge.
   - Quick search preview shortcut.
   - Limited-time **Nitro Cold Brew 20% OFF** promo banner (`LOUNGE20`).
   - Category selector pills (*Espresso, Cold Brew, Latte, Beans, Pastries*).
   - 2-Column responsive grid with interactive drink cards, live ratings, favorite toggles, and instant add-to-cart buttons.
   - Pull-to-refresh with animated indicators.

3. **Product Details Screen (`/details/:id`)**:
   - Hero header with high-resolution imagery and dark vignette gradient.
   - Roast level, origin altitude badge, and calorie metrics.
   - Cup size selection (*Small 8 oz, Medium 12 oz, Large 16 oz*) with dynamic surcharge calculation.
   - Milk customization (*Oat Milk, Whole Milk, Almond Milk, No Milk*).
   - Sweetness level selection (*No Sugar, Less Sweet, Regular Sweet*).
   - Sticky bottom ordering bar with dynamic price and quantity counter.

4. **Cart & Order Summary Screen (`/cart`)**:
   - Reactive BLoC-managed shopping cart with individual item quantity adjustments.
   - Custom discount promo codes (`LOUNGE20` for 20% off, `VIP50` for 50% off).
   - Accurate cost breakdown: Subtotal, Barista Delivery Fee, Promo Savings, and Total.
   - "Place Lounge Order" celebration modal with custom receipt ID (`#CL-XXXXXX`).

5. **User Profile & Loyalty Screen (`/profile`)**:
   - Live integration with **DummyJSON API** (`https://dummyjson.com/users/1`) to fetch user profile (Emily Johnson).
   - **Diamond Lounge VIP Pass** card with live Beans point balance (1,450+ pts).
   - Interactive reward redemption: Redeem points for complimentary drink vouchers.
   - Delivery addresses, order history count, notification controls, and session options.

6. **Search & Favorites Screen (`/search`)**:
   - Segmented TabBar: Live Search vs. Saved Favorites.
   - Instant search across drinks, descriptions, and categories.
   - Quick category pills and `4.8+ Stars` rating filter chip.
   - Full favorite drink management via dedicated `FavoritesBloc`.

---

## 🏛️ Clean Architecture Layer Breakdown

The project follows strict separation of concerns into **Core** and **Features** layers:

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart       # DummyJSON endpoints, timeouts, and retry limits
│   │   └── app_colors.dart          # Rich espresso, caramel gold, and velvet cream palette
│   ├── di/
│   │   └── injection_container.dart # Asynchronous GetIt dependency injection setup
│   ├── errors/
│   │   ├── exceptions.dart          # ServerException, NetworkException, CacheException
│   │   └── failures.dart            # ServerFailure, NetworkFailure, CacheFailure
│   ├── network/
│   │   └── network_client.dart      # HTTP client wrapped with RetryOptions (exponential backoff)
│   ├── routes/
│   │   └── app_router.dart          # GoRouter with ShellRoute navigation and parameter handling
│   ├── theme/
│   │   └── app_theme.dart           # Dark/warm luxury coffee theme (Material 3)
│   └── utils/
│       └── currency_helper.dart     # Currency formatting utility
├── features/
│   ├── coffee/
│   │   ├── data/
│   │   │   ├── datasources/         # CoffeeRemoteDataSource (DummyJSON + curated lounge items)
│   │   │   ├── models/              # CoffeeProductModel, CoffeeResponseModel (JsonSerializable)
│   │   │   └── repositories/        # CoffeeRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/            # CoffeeProduct entity
│   │   │   ├── repositories/        # CoffeeRepository interface
│   │   │   └── usecases/            # GetCoffeeProductsUseCase, GetCoffeeDetailsUseCase, SearchCoffeeUseCase
│   │   └── presentation/
│   │       └── bloc/                # CoffeeBloc, CoffeeEvent, CoffeeState
│   ├── cart/
│   │   ├── domain/entities/         # CartItem entity
│   │   └── presentation/bloc/       # CartBloc, CartEvent, CartState (Loading, Empty, Loaded, OrderSuccess)
│   ├── profile/
│   │   ├── data/                    # UserProfileModel, ProfileRemoteDataSource, ProfileRepositoryImpl
│   │   ├── domain/                  # UserProfile entity, ProfileRepository, GetUserProfileUseCase
│   │   └── presentation/bloc/       # ProfileBloc, ProfileEvent, ProfileState
│   ├── favorites/
│   │   └── presentation/bloc/       # FavoritesBloc, FavoritesEvent, FavoritesState
│   └── presentation/
│       ├── screens/                 # 6 Screens (Splash, Home, Details, Cart, Profile, Search)
│       └── widgets/                 # Reusable CoffeeCard, CategoryChip, StateViews, Shell
└── main.dart                        # WidgetsFlutterBinding, async initDependencies, ResponsiveSizer
```

---

## 🛠️ Technical Stack & Dependencies

- **State Management**: [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (v9.1+)
- **Routing**: [`go_router`](https://pub.dev/packages/go_router) (v18.0+)
- **Dependency Injection**: [`get_it`](https://pub.dev/packages/get_it) (v9.3+)
- **Responsiveness**: [`responsive_sizer`](https://pub.dev/packages/responsive_sizer) (v3.3+)
- **Resilient Networking**: [`http`](https://pub.dev/packages/http) with [`retry`](https://pub.dev/packages/retry) exponential backoff
- **Serialization**: [`json_annotation`](https://pub.dev/packages/json_annotation) & [`json_serializable`](https://pub.dev/packages/json_serializable)
- **Code Generation**: [`build_runner`](https://pub.dev/packages/build_runner)
- **Value Equality**: [`equatable`](https://pub.dev/packages/equatable)

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/hashimalsobhi/flutter_coffee_app_clean_arch.git
cd flutter_coffee_app_clean_arch
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Generate models & serialization files
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run tests
```bash
flutter test
```

### 5. Run the application
```bash
flutter run
```

---

## ☕ Architectural Highlights

- **Resilience**: Every remote network request to DummyJSON executes within a 3-attempt exponential backoff retry loop (`NetworkClient`).
- **Global Responsiveness**: Root wrapped in `ResponsiveSizer` enabling dynamic scale across phone, tablet, and foldable form factors.
- **State Coverage**: Every screen deterministically handles all four BLoC states (`Loading`, `Success/Loaded`, `Empty`, and `Error`) with stylized feedback.
- **Zero Lints/Errors**: Verified with `flutter analyze` with 0 warnings.
