import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/Account.dart';

void main() {
  group('LoginPage', () {
    testWidgets('Validate phone number', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      final phoneTextField = find.byType(TextFormField).first;
      final loginButton = find.text('Login');

      // Invalid phone number (empty)
      await tester.enterText(phoneTextField, '');
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('*This phone number is not valid.'), findsOneWidget);

      // Valid phone number
      await tester.enterText(phoneTextField, '1234567890');
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('*This phone number is not valid.'), findsNothing);
    });

    // Add more test cases for login functionality if needed
  });

  group('SignUpPage', () {
    testWidgets('Validate phone number', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      final phoneTextField = find.byType(TextFormField).at(1);
      final signUpButton = find.text('Sign Up');

      // Invalid phone number (empty)
      await tester.enterText(phoneTextField, '');
      await tester.tap(signUpButton);
      await tester.pump();
      expect(find.text('*This phone number is not valid.'), findsOneWidget);

      // Valid phone number
      await tester.enterText(phoneTextField, '1234567890');
      await tester.tap(signUpButton);
      await tester.pump();
      expect(find.text('*This phone number is not valid.'), findsNothing);
    });
  });
}
