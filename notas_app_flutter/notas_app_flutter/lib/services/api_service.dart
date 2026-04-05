import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../utils/constants.dart';

class ApiService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Note>> getNotes() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/notes'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Note.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener notas');
    }
  }

  Future<bool> createNote(Note note) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/notes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': note.title,
        'content': note.content,
      }),
    );

    return response.statusCode == 201;
  }

  Future<bool> updateNote(Note note) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/api/notes/${note.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': note.title,
        'content': note.content,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteNote(int id) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/notes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}