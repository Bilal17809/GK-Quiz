import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  final GenerativeModel _gm = GenerativeModel(
    model: "gemini-2.0-flash",
    apiKey: "AIzaSyC6BcnlWO4hHGLL6gVGfrlrxZ4mVLrUEAw",
  );

  // Method to handle conversation messages
  Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      // Convert messages to a single prompt with proper system context handling
      String prompt = _convertMessagesToPrompt(messages);
      final content = [Content.text(prompt)];
      final response = await _gm.generateContent(content);
      return response.text ?? "No response generated";
    } catch (e) {
      return "Error generating content: ${e.toString()}";
    }
  }

  // Fixed helper method to properly handle system context
  String _convertMessagesToPrompt(List<Map<String, String>> messages) {
    if (messages.isEmpty) return "";

    StringBuffer prompt = StringBuffer();

    // Handle system message first (if exists)
    var systemMessage = messages.firstWhere(
      (msg) => msg['role'] == 'system',
      orElse: () => <String, String>{},
    );

    if (systemMessage.isNotEmpty) {
      prompt.writeln('System Instructions: ${systemMessage['content']}');
      prompt.writeln('---');
    }

    // Process conversation history (skip system messages)
    var conversationMessages =
        messages.where((msg) => msg['role'] != 'system').toList();

    if (conversationMessages.isEmpty) return prompt.toString().trim();

    // If there's only one conversation message, add it directly
    if (conversationMessages.length == 1) {
      prompt.writeln('User: ${conversationMessages.first['content'] ?? ""}');
      return prompt.toString().trim();
    }

    // Convert conversation history to formatted prompt
    for (var message in conversationMessages) {
      String role = message['role'] ?? 'user';
      String content = message['content'] ?? '';

      if (role == 'user') {
        prompt.writeln('User: $content');
      } else if (role == 'assistant') {
        prompt.writeln('Assistant: $content');
      }
    }

    return prompt.toString().trim();
  }

  // Alternative method using chat sessions (also fixed for system context)
  Future<String> sendChatMessage(List<Map<String, String>> messages) async {
    try {
      // Extract system context if present
      var systemMessage =
          messages.where((msg) => msg['role'] == 'system').firstOrNull;
      var conversationMessages =
          messages.where((msg) => msg['role'] != 'system').toList();

      // Build the prompt with system context
      StringBuffer fullPrompt = StringBuffer();

      if (systemMessage != null) {
        fullPrompt.writeln('System: ${systemMessage['content']}');
        fullPrompt.writeln('---');
      }

      // Add the latest user message
      var lastUserMessage = conversationMessages.lastWhere(
        (msg) => msg['role'] == 'user',
        orElse: () => <String, String>{},
      );

      if (lastUserMessage.isNotEmpty) {
        fullPrompt.writeln('User: ${lastUserMessage['content']}');
      }

      final content = [Content.text(fullPrompt.toString())];
      final response = await _gm.generateContent(content);
      return response.text ?? "No response generated";
    } catch (e) {
      return "Error in chat: ${e.toString()}";
    }
  }
}
