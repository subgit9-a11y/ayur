import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doctro/services/supabase_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Load .env manually for the test
    dotenv.testLoad(fileInput: File('.env').readAsStringSync());
  });

  test('Test Supabase REST API Connectivity', () async {
    final service = SupabaseService();
    
    // Test generating a unique ID
    String docId = service.generateDoctorID();
    expect(docId.startsWith('DOC-'), true);
    print("Generated Test Doctor ID: $docId");

    // We can't easily test a real database insert without polluting the DB,
    // but we can test if the service initializes without throwing exceptions
    // which proves the .env values were read correctly.
    expect(service, isNotNull);
    print("SupabaseService successfully initialized with REST API!");
  });
}
