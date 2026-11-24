import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // TODO: Replace with your secure Groq API key or load from secure environment
  static const String _apiKey = 'YOUR_GROQ_API_KEY';
  static const String _endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  // System prompt to instruct the AI chatbot about Campus Food Ordering app context
  static const String _systemPrompt = '''
You are FoodieBot, an AI assistant for "Campus Bites", a campus food ordering application designed for university students and staff.
You help users find food items, explore categories (Burgers, Pizza, Fast Food, Chinese, Desi Meals, Drinks, Desserts), suggest popular food, explain the ordering process, check order status, and navigate campus pickup locations (Main Library Plaza, Engineering Bldg Cafeteria, Student Center Block B, Medical Complex Gate 1, Business School Lawn, Hostel Block 4 Entrance).
Be polite, concise, helpful, and friendly.
''';

  static Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
          'max_tokens': 512,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          final message = choices[0]['message'];
          if (message != null && message['content'] != null) {
            return message['content'].toString().trim();
          }
        }
        return 'I received an empty response from the AI server.';
      } else if (response.statusCode == 429) {
        return '⚠️ Rate limit or token quota exceeded. Please wait a moment before sending another message.';
      } else if (response.statusCode == 401) {
        return '⚠️ Authentication error: Invalid API key.';
      } else {
        return '⚠️ Server error (${response.statusCode}): Unable to process your request right now.';
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException') || e.toString().contains('timeout')) {
        return '⏱️ Request timed out. Please check your network connection.';
      }
      return '⚠️ Error connecting to AI assistant: ${e.toString()}';
    }
  }
}
