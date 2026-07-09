import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = Uri.parse('https://astra.ayureze.in/api/v1/auth/doctor_register');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "name": "Subash",
      "email": "subgit9@gmail.com",
      "phone": "1234567890",
      "password": "password"
    })
  );
  print('Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');
}
