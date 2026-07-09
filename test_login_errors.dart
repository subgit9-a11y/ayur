import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Test wrong password
  var res = await http.post(
    Uri.parse('https://astra.ayureze.in/api/v1/auth/doctor_login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": "subgit9@gmail.com",
      "password": "wrong_password_test"
    }),
  );
  print('Wrong password status: ${res.statusCode}');
  print('Wrong password response: ${res.body}');

  // Test non-existent user
  var res2 = await http.post(
    Uri.parse('https://astra.ayureze.in/api/v1/auth/doctor_login'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": "nonexistent_subgit999@gmail.com",
      "password": "wrong_password_test"
    }),
  );
  print('Non-existent status: ${res2.statusCode}');
  print('Non-existent response: ${res2.body}');
}
