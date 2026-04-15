import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Resumo {
  final String id, titulo, objetivo, metodologia, resultados, conclusao;
  final List<String> palavrasChave;
  final DateTime criadoEm;

  Resumo({
    required this.id, required this.titulo, required this.objetivo,
    required this.metodologia, required this.resultados, 
    required this.conclusao, required this.palavrasChave, required this.criadoEm,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'titulo': titulo, 'objetivo': objetivo, 'metodologia': metodologia,
    'resultados': resultados, 'conclusao': conclusao, 'palavrasChave': palavrasChave,
    'criadoEm': criadoEm.toIso8601String(),
  };

  factory Resumo.fromMap(Map<String, dynamic> map) {
    return Resumo(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      objetivo: map['objetivo'] ?? '',
      metodologia: map['metodologia'] ?? '',
      resultados: map['resultados'] ?? '',
      conclusao: map['conclusao'] ?? '',
      palavrasChave: List<String>.from(map['palavrasChave'] ?? []),
      criadoEm: DateTime.tryParse(map['criadoEm'] ?? '') ?? DateTime.now(),
    );
  }
}


class RepositorioResumos {
  static const _key = 'historico_resumos';

  Future<void> salvar(Resumo resumo) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await buscarTodos();
    lista.insert(0, resumo);
    final json = jsonEncode(lista.take(10).map((e) => e.toMap()).toList());
    await prefs.setString(_key, json);
  }

  Future<List<Resumo>> buscarTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Resumo.fromMap(e)).toList();
  }
}