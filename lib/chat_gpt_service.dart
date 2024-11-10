import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiKey =
      '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';

  Future<String> obtenerRespuesta(String pregunta) async {
    const url = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': pregunta}
      ],
      'max_tokens': 100,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Error al obtener respuesta de ChatGPT');
      }
    } catch (e) {
      return 'Error: No se pudo obtener respuesta.';
    }
  }
}
