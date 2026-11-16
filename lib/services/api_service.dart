import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/travel_destination.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<String> simulateDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Підключення до туристичного сервісу встановлено';
  }

  Future<List<TravelDestination>> getDestinations() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.take(15).map((item) => TravelDestination.fromJson(item)).toList();
      } else {
        throw Exception('Помилка сервера: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Відсутнє підключення до інтернету.');
    } on TimeoutException {
      throw Exception('Час очікування запиту вичерпано.');
    } catch (e) {
      throw Exception('Помилка завантаження даних: $e');
    }
  }

  Future<TravelDestination> createDestination(String title, String description) async {
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({
              'title': title,
              'body': description,
              'userId': 1,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return TravelDestination.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Не вдалося створити напрямок: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Відсутнє підключення до інтернету.');
    } on TimeoutException {
      throw Exception('Час очікування запиту вичерпано.');
    }
  }
}
