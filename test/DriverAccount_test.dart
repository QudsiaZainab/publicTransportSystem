import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:my_app/DriverAccount.dart'; // Assuming your main file is named driver_account.dart

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LoginPage', () {
    testWidgets('Login with valid phone number', (WidgetTester tester) async {
      final mockSharedPreferences = MockSharedPreferences();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );

      // Mock the SharedPreferences instance
      when(mockSharedPreferences.setString("any", "any"))
          .thenAnswer((_) => Future.value(true));

      // Enter a valid phone number
      await tester.enterText(find.byType(TextFormField), '03039204060');
      await tester.tap(find.byType(ElevatedButton));

      // Wait for navigation
      await tester.pumpAndSettle();

      // Verify that the login was successful by checking if the DriverAccount screen is shown
      expect(find.text('Driver Account'), findsOneWidget);
    });
  });

  group('SignUpPage', () {
    testWidgets('Sign up with valid credentials', (WidgetTester tester) async {
      final mockSharedPreferences = MockSharedPreferences();

      await tester.pumpWidget(
        MaterialApp(
          home: SignUpPage(),
        ),
      );

      // Mock the SharedPreferences instance
      when(mockSharedPreferences.setString("any", "any"))
          .thenAnswer((_) => Future.value(true));

      // Enter valid name and phone number
      await tester.enterText(find.byType(TextFormField).first, 'Qudsia Zainab');
      await tester.enterText(find.byType(TextFormField).last, '03039204060');
      await tester.tap(find.byType(ElevatedButton));

      // Wait for navigation
      await tester.pumpAndSettle();

      // Verify that the sign-up was successful by checking if the success dialog is shown
      expect(find.text('Signup Successful'), findsOneWidget);
    });
  });
}
