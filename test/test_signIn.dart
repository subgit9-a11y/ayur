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
import 'package:mockito/mockito.dart';

// Create mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  setUpAll(() async {
    // Initialize Firebase for testing
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // Firebase already initialized, continue
    }
  });

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
