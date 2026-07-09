import 'dart:convert';
import 'package:doctro/model/login.dart'; // adjust path if needed

void main() {
  String jsonStr = '{"success":true,"msg":"Login successful","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...","data":{"id":55,"name":"Testsubash","email":"h7kgz53ib4@bltiwd.com","phone":"7598753230","token":"...","is_filled":1,"subscription_status":1,"image":"defaultUser.png","agoraAppId":"aaf7c4d9c2d849368b79b1583e5023ed","agoraAppCertificate":"669fcfe648894e709af71efd7f2068ae"}}';
  
  Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
  try {
    LoginResponse response = LoginResponse.fromJson(jsonMap);
    print("Parsed successfully!");
    print("Success: ${response.success}");
    print("Data id: ${response.data?.id}");
    print("Verify: ${response.data?.verify}");
  } catch (e, stacktrace) {
    print("Error parsing: $e");
    print(stacktrace);
  }
}
