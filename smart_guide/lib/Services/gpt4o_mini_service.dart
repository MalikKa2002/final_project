// lib/services/gpt4o_mini_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class Gpt4oMiniService {
  // Replace with your actual AIMLAPI key (including the "Bearer " prefix if needed).
  static const String _authorization = 'Bearer f264041c57b54d5285889958cd0a1902';

  /// Sends [userMessage] to AIMLAPI’s gpt-4o-mini-2024-07-18 endpoint
  /// and returns the assistant’s reply.
  static Future<String> getChatResponse(String userMessage) async {
    final url = Uri.parse('https://api.aimlapi.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _authorization,
    };

    final body = jsonEncode({
      'model': 'gpt-4o-mini-2024-07-18',
      'messages': [
        {'role': 'user', 'content': userMessage}
      ],
      'temperature': 0.7,
      'top_p': 0.7,
      'frequency_penalty': 1,
      'max_output_tokens': 512,
      'top_k': 39,
    });

    final response = await http.post(url, headers: headers, body: body);

    // Accept any 2xx as success (200, 201, etc.)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // The API’s JSON looks like:
      // {
      //   "choices": [
      //     {
      //       "index": 0,
      //       "message": { "role":"assistant","content":"..." }
      //       … 
      //     }
      //   ],
      //   …
      // }
      final reply = data['choices'][0]['message']['content'] as String;
      return reply.trim();
    } else {
      throw Exception(
        'gpt-4o-mini API failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
