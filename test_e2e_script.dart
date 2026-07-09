import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Generate random email to avoid duplicate errors
  final uniqueId = DateTime.now().millisecondsSinceEpoch;
  final email = "ai_doc_\$uniqueId@test.com";

  print('================= E2E TEST FLOW =================');
  print('1. Registering with email: \$email');

  final registerUrl = Uri.parse('https://astra.ayureze.in/api/v1/auth/doctor_register');
  
  final regBody = {
    "name": "Test Doctor E2E",
    "email": email,
    "phone": "99\${uniqueId.toString().substring(0, 8)}",
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
    "unique_id": uniqueId.toString(),
    "is_face_verified": 1,
    "is_filled": 1
  };

  int userId = 0;
  String otp = "";

  try {
    final regResponse = await http.post(
      registerUrl,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(regBody),
    );
    
    print('Register Response Code: ' + regResponse.statusCode.toString());
    print('Register Response Body: ' + regResponse.body);
    
    final regData = jsonDecode(regResponse.body);
    if (regData['success'] == true) {
       userId = regData['data']['id'];
       otp = regData['data']['otp'].toString();
       print('=> Successfully registered! User ID: \$userId, OTP: \$otp');
    } else {
       print('=> Registration failed.');
       return;
    }
  } catch (e) {
    print('Register Error: ' + e.toString());
    return;
  }

  // OTP Verification
  print('\\n2. Verifying OTP...');
  // Testing both check_otp and auth/check_otp just in case
  final otpUrls = [
    'https://astra.ayureze.in/api/v1/auth/check_otp',
    'https://astra.ayureze.in/api/v1/check_otp'
  ];

  bool isOtpVerified = false;
  for (String urlStr in otpUrls) {
    final otpUrl = Uri.parse(urlStr);
    try {
      final otpResponse = await http.post(
        otpUrl,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({"user_id": userId, "otp": otp}),
      );
      print('OTP Url: \$urlStr | Code: ' + otpResponse.statusCode.toString());
      print('OTP Response: ' + otpResponse.body);
      
      final otpData = jsonDecode(otpResponse.body);
      if (otpData['success'] == true) {
        print('=> OTP verified successfully!');
        isOtpVerified = true;
        break;
      }
    } catch (e) {
      // ignore
    }
  }

  if (!isOtpVerified) {
    print('=> OTP verification failed.');
    return;
  }

  // Login
  print('\\n3. Logging In...');
  final loginUrl = Uri.parse('https://astra.ayureze.in/api/v1/auth/doctor_login');
  
  try {
    final loginResponse = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": "testpassword",
        "device_token": "test_token"
      }),
    );
    print('Login Response Code: ' + loginResponse.statusCode.toString());
    print('Login Response Body: ' + loginResponse.body);
    
    final loginData = jsonDecode(loginResponse.body);
    if (loginData['success'] == true) {
      print('=> Login successful! Token received: ' + loginData['token'].toString().substring(0, 20) + '...');
      print('================ E2E TEST COMPLETED ================');
    }
  } catch (e) {
    print('Login Error: ' + e.toString());
  }
}
