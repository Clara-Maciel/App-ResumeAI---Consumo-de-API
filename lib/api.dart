import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'modelos.dart';

Future<Resumo> gerarResumoIA(String texto) async {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    throw Exception('GEMINI_API_KEY nao configurada no arquivo .env');
  }

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
  );

  final resposta = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": '''
Retorne apenas um JSON valido, sem markdown, sem crases e sem texto extra.
Use exatamente este formato:
{
  "titulo": "string",
  "objetivo": "string",
  "metodologia": "string",
  "resultados": "string",
  "conclusao": "string",
  "palavrasChave": ["string", "string", "string"]
}

Faça um resumo academico estruturado do texto abaixo:
$texto
''',
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7,
        "responseMimeType": "application/json",
      }
    }),
  );

  if (resposta.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(resposta.body);
    final candidatos = json['candidates'] as List?;
    if (candidatos == null || candidatos.isEmpty) {
      debugPrint("Resposta Gemini sem candidatos: ${resposta.body}");
      throw Exception('A API nao retornou conteudo para gerar o resumo');
    }

    String? conteudoTexto;
    final content = candidatos.first['content'];
    final parts = content?['parts'] as List?;
    if (parts != null && parts.isNotEmpty) {
      conteudoTexto = parts.first['text'] as String?;
    }

    if (conteudoTexto == null || conteudoTexto.trim().isEmpty) {
      final finishReason = candidatos.first['finishReason'];
      debugPrint("Resposta Gemini sem texto util: ${resposta.body}");
      throw Exception(
          'A API nao retornou um resumo valido (${finishReason ?? "sem motivo informado"})');
    }

    conteudoTexto = conteudoTexto.trim();
    if (conteudoTexto.startsWith("```")) {
      final linhas = conteudoTexto.split('\n');
      if (linhas.isNotEmpty && linhas.first.contains("```")) linhas.removeAt(0);
      if (linhas.isNotEmpty && linhas.last.contains("```")) linhas.removeLast();
      conteudoTexto = linhas.join('\n').trim();
    }

    final Map<String, dynamic> dados = Map<String, dynamic>.from(
      jsonDecode(conteudoTexto) as Map,
    );

    return Resumo.fromMap({
      ...dados,
      'palavrasChave': List<String>.from(dados['palavrasChave'] ?? []),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'criadoEm': DateTime.now().toIso8601String(),
    });
  } else {
    debugPrint("Erro API Gemini: ${resposta.statusCode} - ${resposta.body}");
    String mensagem = 'Falha ao gerar resumo';
    try {
      final corpo = jsonDecode(resposta.body) as Map<String, dynamic>;
      final erro = corpo['error'];
      if (erro is Map && erro['message'] != null) {
        mensagem = erro['message'].toString();
      }
    } catch (_) {
    }
    throw Exception(mensagem);
  }
}
