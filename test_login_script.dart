import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  Future<void> testLogin(String endpoint) async {
    final url = Uri.parse('https://astra.ayureze.in/api/v1/$endpoint');
    final body = {
      "email": "h7kgz53ib4@bltiwd.com",
      "password": "test@1234",
      "device_token": "test_token"
    };

    print('Sending POST request to ' + url.toString());
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode(body),
      );
      
      print('Status Code: ' + response.statusCode.toString());
      print('Response: ' + response.body);
      print('-------------------');
    } catch (e) {
      print('Error: ' + e.toString());
    }
  }

  await testLogin('auth/login');
  await testLogin('auth/doctor_login');
}
