import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  var res = await http.post(
    Uri.parse('https://astra.ayureze.in/api/v1/api/doctors/register'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "name": "Test",
      "email": "subgit9@gmail.com",
      "password": "test"
    }),
  );
  print('Register status: ${res.statusCode}');
  print('Register response: ${res.body}');
}
