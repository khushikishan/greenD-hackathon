import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _apiKey;

  ApiService(this._apiKey);

  
  final String _baseUrl = "https://generativelanguage.googleapis.com";

  
  Future<void> saveConversationHistory(List<Map<String, String>> conversationHistory) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(conversationHistory);
    await prefs.setString('conversation_history', historyJson);
  }

  
  Future<List<Map<String, String>>> loadConversationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('conversation_history');
    if (historyJson != null) {
      return List<Map<String, String>>.from(jsonDecode(historyJson));
    }
    return [];
  }

  Future<Map<String, dynamic>> sendMessage(
    String message, List<Map<String, String>> conversationHistory) async {
  final url = Uri.parse("https://generativelanguage.googleapis.com/chat");
  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "messages": conversationHistory,
        "user_message": message,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to send message: ${response.body}");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}
}
