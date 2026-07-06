import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctro/screens/auth/SignIn.dart';
import 'package:provider/provider.dart';
import 'package:doctro/chat/providers/auth_provider.dart' as chat;
import 'package:doctro/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctro/localization/language_localization.dart';

void main() {
  testWidgets('SignIn Screen mounts without exception', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<chat.AuthProvider>(
            create: (_) => chat.AuthProvider(
              firebaseAuth: FirebaseAuth.instance,
              prefs: prefs,
              firebaseFirestore: FirebaseFirestore.instance,
            ),
          ),
        ],
        child: MaterialApp(
          home: SignIn(),
          localizationsDelegates: [
            LanguageLocalization.delegate,
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SignIn), findsOneWidget);
  });
}
