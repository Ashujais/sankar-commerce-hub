# Sankar Commerce Hub 🚀

**Flutter Development Internship Assignment**  
**Role:** Flutter Developer Intern  
**Company:** Sankar Group  
**Framework:** Flutter 3.47.2 • Dart 3.13.2 • Material 3  

---

## 📌 Executive Summary

**Sankar Commerce Hub** is a responsive mobile application developed for **Sankar Group**. The application demonstrates modern mobile software engineering practices: a multi-tier clean architecture, robust state management using **Provider**, live REST API consumption with graceful offline failover, durable data persistence using **SharedPreferences**, form validation, dynamic search, category filtering, multi-criteria sorting, and responsive Android UI design.

---

## 📱 Tasks & Core Screens Completed

### Task 1 – App Design & Setup
- **Responsive Layout:** Responsive layout adapting across various Android device screen sizes and densities.
- **Brand Identity:** Styled in Sankar Group’s executive corporate palette (Deep Navy `#0F2B48`, Amber Gold `#F59E0B`, Emerald Green `#10B981`).
- **Dynamic Theming:** Seamless support for both **Light Mode** and **Dark Mode** with persistent theme selection across app restarts.
- **Animated Splash Screen:** Custom animated brand entrance with logo scaling, fade transitions, and automated session restoration.

### Task 2 – Core Screens
1. **Login & Signup Screens (`lib/views/auth/`):**
   - User authentication UI with tabbed login and registration flows.
   - Comprehensive input validation (RFC email regex, minimum 6-character passwords, matching password verification, phone validation).
   - Password visibility toggle (eye icon).
   - "Remember Me" credential persistence.
   - **One-Click Quick Demo Sign In** for evaluator testing.
2. **Home Dashboard Screen (`lib/views/home/home_screen.dart`):**
   - Personalized user greeting and corporate branding.
   - Live API connectivity status indicator (Live Sync vs. Offline Mode).
   - Interactive auto-advancing **Promotional Banner Carousel** (`BannerCarousel`).
   - 3 Live **Dashboard Metric Cards** (Total Catalog Items, Saved Wishlist Items, Active Cart Items).
   - Horizontal **Division & Category Selector Chips**.
   - Horizontal scroll of **Sankar Featured Picks**.
   - 2-Column responsive grid of **Trending Industrial Catalog Products**.
3. **Product Listing Screen (`lib/views/products/product_listing_screen.dart`):**
   - Real-time instant search bar with clear button.
   - Category filtering chips ('All', 'Industrial Tools', 'Automotive', 'Electronics', 'Watches', etc.).
   - Sort bottom sheet (Price: Low to High, Price: High to Low, Customer Rating, Biggest Discount, Featured).
   - **View Mode Switcher:** Toggle between 2-column Grid and single-column List view.
   - Complete state handling: Animated skeleton shimmer loading, informative error view with "Try Again", and empty search results view with "Reset Filters".
   - Pull-to-refresh (`RefreshIndicator`) for live catalog sync.
4. **Product Details Screen (`lib/views/products/product_detail_screen.dart`):**
   - Interactive high-resolution image gallery with page indicators.
   - Brand tag, category pill, stock level status badge ("X IN STOCK" / "OUT OF STOCK").
   - Pricing display with discount calculation and original price strikethrough.
   - Customer rating stars and verified review count.
   - Expandable product description with "Read More / Read Less" toggle.
   - Technical specifications table (SKU, weight, warranty terms, shipping logistics, return policy).
   - Verified customer reviews section with ratings and comments.
   - Interactive quantity counter (`-`, `count`, `+`) with available stock constraints.
   - Persistent wishlist favorite toggle in app bar.
   - Sticky bottom action bar with dynamic total calculation, "Add to Cart", and "Buy Now" checkout dialog.

### Bonus Production Screens Included
5. **Shopping Cart & Checkout Screen (`lib/views/cart/cart_screen.dart`):**
   - Real-time item list with quantity steppers and delete actions.
   - Free shipping progress bar (Free delivery over \$50).
   - Promo code input system (Enter promo code `SANKAR10` for an immediate 10% discount).
   - Itemized summary (Subtotal, Discount, Shipping, Grand Total).
   - Checkout dialog with simulated corporate order dispatch.
6. **Wishlist / Favorites Screen (`lib/views/favorites/favorites_screen.dart`):**
   - Dedicated bookmark view reading saved products from `SharedPreferences`.
   - Instant cart additions and batch clear wishlist option.
7. **Profile & Settings Screen (`lib/views/profile/profile_screen.dart`):**
   - User profile card with verified associate badge.
   - Dark Mode / Light Mode toggle.
   - System integration diagnostics (REST API status and local storage metrics).
   - About Sankar Group assignment modal.
   - "Reset Local Storage" maintenance tool to verify fresh install state.
   - Sign Out flow with confirmation.

---

## 🛠️ Architecture & Folder Structure

The project follows a clean, decoupled layer architecture separating presentation, domain models, business logic providers, and data services:

```text
lib/
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart     # Public REST API URLs & endpoints
│   │   ├── app_colors.dart        # Sankar Group brand color palette
│   │   └── app_constants.dart     # App constants, keys, demo credentials
│   ├── theme/
│   │   └── app_theme.dart         # Material 3 light & dark theme definitions
│   └── utils/
│       └── validators.dart        # Form input validators
├── models/
│   ├── cart_item_model.dart       # Cart item model with quantity & totals
│   ├── product_model.dart         # Product data model with pricing logic
│   ├── review_model.dart          # Customer review model
│   └── user_model.dart            # Authenticated user profile model
├── providers/
│   ├── auth_provider.dart         # Authentication & session state
│   ├── cart_provider.dart         # Cart operations, promo codes, persistence
│   ├── favorite_provider.dart     # Wishlist state & local storage
│   ├── product_provider.dart      # Catalog fetching, search, filter & sorting
│   └── theme_provider.dart        # Light / Dark mode state management
├── services/
│   ├── api_service.dart           # HTTP client with timeout & offline failover
│   ├── mock_data.dart             # Structured offline catalog fallback
│   └── storage_service.dart       # SharedPreferences persistence engine
├── views/
│   ├── auth/                      # Login & Registration screens
│   ├── cart/                      # Shopping cart & order checkout
│   ├── favorites/                 # Wishlist screen
│   ├── home/                      # Dashboard & BottomNavigationBar
│   ├── products/                  # Listing catalog & product details
│   └── splash/                    # Animated splash screen
├── widgets/                       # Reusable UI components
│   ├── banner_carousel.dart
│   ├── category_chip.dart
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── empty_state_view.dart
│   ├── error_view.dart
│   ├── loading_shimmer.dart
│   ├── product_card.dart
│   └── star_rating.dart
└── main.dart                      # App entry point & MultiProvider setup
```

---

## 🌐 Public API & Data Resilience Strategy

1. **Live REST API:**
   - Base URL: `https://dummyjson.com/products`
   - Endpoints integrated:
     - `/products?limit=100` (Full catalog)
     - `/products/categories` (Category list)
     - `/products/search?q={query}` (Live server search)
     - `/products/{id}` (Single product detail)
2. **Offline Resilience & Auto-Failover:**
   - Network requests are wrapped with a `12-second` timeout.
   - If internet access is unavailable or interrupted (`SocketException`, `TimeoutException`), the application automatically activates the structured local Sankar catalog without crashing.
   - An offline notification banner informs the user while preserving search, filtering, wishlist, and cart operations.

---

## 💾 Local Data Persistence (Task 5)

Data persistence is managed via **`SharedPreferences`**:
- `sankar_user_session`: Persists the logged-in user profile across app restarts.
- `sankar_remember_me`: Controls whether the user is automatically logged in from the splash screen.
- `sankar_theme_mode`: Remembers the user's Dark / Light theme preference.
- `sankar_favorites_list`: Persists the list of saved product IDs.
- `sankar_cart_items`: Persists the serialized cart items, quantities, and totals.

---

## 📦 Packages Used

| Package | Version | Purpose |
|---|---|---|
| `provider` | `^6.1.5+1` | Reactive state management using `ChangeNotifier` and `Consumer` |
| `http` | `^1.6.0` | REST API networking with timeouts and status code inspection |
| `shared_preferences` | `^2.5.5` | Key-value local storage for session, favorites, cart, and theme |
| `google_fonts` | `^6.3.3` | Clean typography (Poppins) |
| `intl` | `^0.20.3` | Number and currency formatting |
| `cupertino_icons` | `^1.0.8` | Cupertino fallback iconography |

---

## 🚀 How to Run the Application

### Prerequisites
- Flutter SDK (version `>= 3.13.0`)
- Android Studio / VS Code with Flutter extension
- An Android Emulator, physical Android device, Chrome, or Windows desktop

### Steps
1. **Clone or navigate to the project directory:**
   ```bash
   cd F:\Sankar_Flutter2
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify code quality:**
   ```bash
   flutter analyze
   ```
   *(Expected result: No issues found!)*

4. **Run the automated test suite:**
   ```bash
   flutter test
   ```
   *(Expected result: All 14 unit and widget tests pass)*

5. **Run the application:**
   - On an Android device/emulator:
     ```bash
     flutter run
     ```
   - In Google Chrome (Web):
     ```bash
     flutter run -d chrome
     ```
   - On Windows Desktop:
     ```bash
     flutter run -d windows
     ```

### Demo Login Credentials
For rapid evaluator testing, click the **"Quick Demo Sign In"** button on the login screen, or enter:
- **Email:** `intern@sankargroup.com`
- **Password:** `Password123!`
- **Valid Promo Code:** `SANKAR10` (10% discount on cart checkout)

---

## 🧪 Testing Suite Coverage

The project includes unit and widget tests:
- **`test/models_test.dart`**: Tests `ProductModel` JSON serialization, discount calculation, `UserModel` roundtrip, and `CartItemModel` totals.
- **`test/validators_test.dart`**: Tests regex email verification, password length criteria, name validation, and confirmation match.
- **`test/providers_test.dart`**: Tests `CartProvider` operations, promo code application, and `ProductProvider` category/search filters.
- **`test/widget_test.dart`**: Widget tests for `StarRating`, `CustomButton`, and `LoginScreen`.

---

## 📄 Evaluation Criteria Verification

| Evaluation Area | Weight | Implementation Details |
|---|---|---|
| **UI Design & Responsiveness** | 20% | Material 3, Sankar brand colors, Light & Dark themes, custom shimmer loaders, responsive grids/lists |
| **Flutter & Dart Code Quality** | 20% | Null-safe Dart 3, clean architecture, zero analyzer warnings/errors, reusable components |
| **Functionality & Navigation** | 20% | 5 complete screens + 2 auth flows + splash screen, form validation, search, filter, sort, cart & buy now |
| **API & Data Integration** | 20% | Public REST API (`dummyjson.com`), live search & categories, structured offline fallback |
| **Code Organization & Persistence** | 20% | Clean directory structure, `SharedPreferences` persistent session, favorites, cart, and theme |
