import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // We will test both endpoints to see which one works
  final endpoints = [
    'https://astra.ayureze.in/api/v1/auth/doctor_register',
    'https://astra.ayureze.in/api/v1/doctor_register'
  ];
  
  final body = {
    "name": "Test Doctor AI",
    "email": "testdoc_ai_999@bltiwd.com",
    "phone": "9999999999",
    "phone_code": "+91",
    "password": "testpassword",
    "dob": "1990-01-01",
    "gender": "Male",
    "treatment_id": 1,
    "category_id": 1,
    "treatment": "1",
    "category": "1",
    "education": "MBBS",
    "experience": "5",
    "appointment_fees": "500",
    "clinic_fee": "500",
    "video_appointment_fees": "600",
    "video_fee": "600",
    "hospital_id": "LIC123456",
    "license_number": "LIC123456",
    "based_on": "Commission",
    "language": "English",
    "desc": "Testing signup flow from AI",
    "certificate": "https://test.com/cert.jpg",
    "id_proof": "https://test.com/id.jpg",
    "unique_id": "test_unique_id_123",
    "is_face_verified": 1,
    "is_filled": 1
  };

  for (String urlStr in endpoints) {
    final url = Uri.parse(urlStr);
    print('\\n=========================================');
    print('Testing Endpoint: \$url');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(body),
      );
      
      print('Status Code: ' + response.statusCode.toString());
      print('Response: ' + response.body);
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }
}
