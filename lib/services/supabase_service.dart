import 'dart:io';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  late Dio _dio;
  late String _supabaseUrl;
  late String _supabaseAnonKey;
  bool _isDummy = false;

  SupabaseService() {
    try {
      _supabaseUrl = dotenv.maybeGet('SUPABASE_URL') ??
          const String.fromEnvironment('SUPABASE_URL');
      _supabaseAnonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ??
          const String.fromEnvironment('SUPABASE_ANON_KEY');
    } catch (_) {
      _supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
      _supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
    }

    if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) {
      print(
          "WARNING: Supabase is not initialized. Configure SUPABASE_URL and SUPABASE_ANON_KEY.");
      _supabaseUrl = "https://dummy.supabase.co";
      _supabaseAnonKey = "dummy_key";
      _isDummy = true;
    }

    _dio = Dio(BaseOptions(
      baseUrl: _supabaseUrl,
      headers: {
        'apikey': _supabaseAnonKey,
        'Authorization': 'Bearer $_supabaseAnonKey',
        'Content-Type': 'application/json',
      },
    ));
  }

  /// Generate a unique Doctor ID
  String generateDoctorID() {
    final year = DateTime.now().year;
    final randomPart = const Uuid().v4().substring(0, 4).toUpperCase();
    return 'DOC-$year-$randomPart';
  }

  /// Store doctor registration data in Supabase
  Future<void> saveDoctorProfile({
    required String doctorId,
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String dob,
    required String? photoUrl,
    required bool isFaceVerified,
  }) async {
    if (_isDummy) {
      print("Bypassing saveDoctorProfile due to dummy Supabase configuration");
      return;
    }
    try {
      await _dio.post('/rest/v1/doctors',
          queryParameters: {
            'on_conflict': 'unique_id',
          },
          options: Options(headers: {'Prefer': 'resolution=merge-duplicates'}),
          data: {
            'unique_id': doctorId,
            'name': name,
            'email': email,
            'phone': phone,
            'gender': gender,
            'dob': dob,
            'photo_url': photoUrl,
            'is_face_verified': isFaceVerified,
            'updated_at': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception("Supabase Database Error: $e");
    }
  }

  /// Upload captured live photo to Supabase Storage
  Future<String?> uploadProfilePhoto(File photoFile, String doctorId) async {
    final fileName =
        '$doctorId/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    if (_isDummy) {
      print("Bypassing uploadProfilePhoto due to dummy Supabase configuration");
      return '$_supabaseUrl/storage/v1/object/public/doctor-profiles/$fileName';
    }
    try {
      final fileBytes = await photoFile.readAsBytes();

      await _dio.post('/storage/v1/object/doctor-profiles/$fileName',
          data: Stream.fromIterable([fileBytes]),
          options: Options(
            headers: {
              'Content-Type': 'image/jpeg',
            },
          ));

      return '$_supabaseUrl/storage/v1/object/public/doctor-profiles/$fileName';
    } catch (e) {
      throw Exception("Supabase Storage Error: $e");
    }
  }

  /// Upload cleaned signature PNG to Supabase Storage
  Future<String?> uploadSignature(
      Uint8List signatureBytes, String doctorId) async {
    final fileName =
        '$doctorId/signature_${DateTime.now().millisecondsSinceEpoch}.png';
    if (_isDummy) {
      print("Bypassing uploadSignature due to dummy Supabase configuration");
      return '$_supabaseUrl/storage/v1/object/public/doctor-profiles/$fileName';
    }
    try {
      await _dio.post('/storage/v1/object/doctor-profiles/$fileName',
          data: Stream.fromIterable([signatureBytes]),
          options: Options(
            headers: {
              'Content-Type': 'image/png',
            },
          ));

      return '$_supabaseUrl/storage/v1/object/public/doctor-profiles/$fileName';
    } catch (e) {
      print("Supabase Signature Upload Error: $e");
      return null;
    }
  }

  /// Update the signature URL in the doctor's database record
  Future<void> updateSignatureUrl(String doctorId, String signatureUrl) async {
    try {
      await _dio.patch('/rest/v1/doctors?unique_id=eq.$doctorId', data: {
        'signature_url': signatureUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Supabase DB Signature Sync Error: $e");
    }
  }

  /// Log document verification metadata in Supabase
  Future<void> logVerificationDocument({
    required String doctorId,
    required String docType,
    required String docNumber,
    required String wasabiUrl,
  }) async {
    try {
      await _dio.post('/rest/v1/doctor_verification_logs', data: {
        'doctor_unique_id': doctorId,
        'document_type': docType,
        'document_number': docNumber,
        'wasabi_url': wasabiUrl,
        'uploaded_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Supabase Verification Log Error: $e");
    }
  }
}
