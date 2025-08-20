import 'package:http/http.dart' as http;
import 'dart:convert';

class TechnicianMessageController {
  final String backendUrl = 'http://10.0.2.2:3000/api/chat';

  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final url = Uri.parse('$backendUrl/$chatId/message');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'senderId': senderId, 'text': text}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatId) async {
    final url = Uri.parse('$backendUrl/$chatId/messages');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Ensure keys/values are String and dynamic
      return data.entries.map((e) => {
        ...Map<String, dynamic>.from(e.value as Map),
        'id': e.key,
      }).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

}
