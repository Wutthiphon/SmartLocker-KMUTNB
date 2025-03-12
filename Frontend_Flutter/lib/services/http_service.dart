import 'package:flutter_cs_locker_project/services/storage/storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  late final String url;
  late final String method;
  late final dynamic data;

  APIService({required this.url, required this.method, this.data});

  dynamic parseResponseBody(String body) {
    try {
      return jsonDecode(body);
    } catch (e) {
      return null;
    }
  }

  // IF Post Put Patch and have data to send
  Future<dynamic> fetch() async {
    String? token = await Storage().getData('AUTH_TOKEN');
    http.Response response = http.Response('', 500);

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (method == 'GET') {
      response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
    } else if (method == 'POST') {
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
    } else if (method == 'PUT') {
      response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
    } else if (method == 'PATCH') {
      response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
    } else if (method == 'DELETE') {
      response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
    }

    if (response.statusCode == 200) {
      return parseResponseBody(response.body);
    } else {
      dynamic errorMessage = parseResponseBody(response.body);

      if (errorMessage != null && errorMessage is Map) {
        return {
          'error': true,
          'statusCode': response.statusCode,
          'message':
              errorMessage['message'] ?? 'Failed to load data from server',
        };
      } else {
        return {
          'error': true,
          'statusCode': response.statusCode,
          'message': 'Failed to load data from server',
        };
      }
    }
  }
}
