import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  final String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  final String _model = 'deepseek/deepseek-r1-0528-qwen3-8b:free';
  final String _apiKey =
      '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';

  Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": _model,
          "messages": messages,
          "max_tokens": 1000,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null &&
            data['choices'].isNotEmpty &&
            data['choices'][0]['message'] != null) {
          final reply = data['choices'][0]['message']['content'];
          return reply?.toString().trim() ?? "No response received";
        } else {
          return "Error: Invalid response format from API";
        }
      } else {
        String errorMessage =
            "Error ${response.statusCode}: ${response.reasonPhrase}";
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage +=
                "\nDetails: ${errorData['error']['message'] ?? errorData['error']}";
          }
        } catch (e) {
          errorMessage += "\nResponse: ${response.body}";
        }
        return errorMessage;
      }
    } catch (e) {
      return "Connection error: ${e.toString()}";
    }
  }
}
