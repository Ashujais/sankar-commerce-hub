import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sankar_app/providers/auth_provider.dart';
import 'package:sankar_app/providers/cart_provider.dart';
import 'package:sankar_app/providers/favorite_provider.dart';
import 'package:sankar_app/providers/product_provider.dart';
import 'package:sankar_app/providers/theme_provider.dart';
import 'package:sankar_app/views/auth/login_screen.dart';
import 'package:sankar_app/widgets/custom_button.dart';
import 'package:sankar_app/widgets/star_rating.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('StarRating renders correct stars and rating text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StarRating(rating: 4.5, reviewCount: 24),
        ),
      ),
    );

    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('(24)'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsWidgets);
    expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);
  });

  testWidgets('CustomButton displays text and triggers callback', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Submit Request',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Submit Request'), findsOneWidget);
    await tester.tap(find.text('Submit Request'));
    await tester.pump();
    expect(tapped, true);
  });

  testWidgets('LoginScreen smoke test', (WidgetTester tester) async {
    final auth = AuthProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
          ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
          ChangeNotifierProvider<FavoriteProvider>(create: (_) => FavoriteProvider()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.textContaining('Welcome to'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Quick Demo Sign In'), findsOneWidget);
  });
}
