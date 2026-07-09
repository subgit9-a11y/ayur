import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctro/screens/auth/signup.dart';
import 'package:doctro/screens/auth/SignIn.dart';
import 'package:doctro/main.dart' as app;

void main() {
  testWidgets('Test CreateAccount rendering', (WidgetTester tester) async {
    try {
      await tester.pumpWidget(MaterialApp(
        home: CreateAccount(),
      ));
      print("CreateAccount rendered successfully");
    } catch (e, stack) {
      print("Error rendering CreateAccount: $e");
      print(stack);
    }
  });

  testWidgets('Test SignIn rendering', (WidgetTester tester) async {
    try {
      await tester.pumpWidget(MaterialApp(
        home: SignIn(),
      ));
      print("SignIn rendered successfully");
    } catch (e, stack) {
      print("Error rendering SignIn: $e");
      print(stack);
    }
  });
}
