import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doctro/screens/auth/signup.dart';
import 'package:doctro/theme/ayureze_theme.dart';
import 'package:doctro/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doctro/localization/language_localization.dart';

void main() {
  testWidgets('Test CreateAccount rendering', (WidgetTester tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      print('FLUTTER ERROR: ${details.exception}');
    };
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(isDark: false)),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            LanguageLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
          ],
          home: Scaffold(
            body: CreateAccount(),
          ),
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    print('Widget pumped successfully');
    
    final textFinder = find.byType(Text);
    print('Found texts: ${textFinder.evaluate().length}');
  });
}
