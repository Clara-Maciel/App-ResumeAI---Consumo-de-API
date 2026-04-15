import 'package:flutter/material.dart';
import '../modelos.dart';
import '../pdf_util.dart';

class TelaLeitura extends StatelessWidget {
  final Resumo resumo;
  const TelaLeitura({super.key, required this.resumo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo'),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () => PdfUtil.compartilharResumo(resumo))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(resumo.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          _item('Objetivo', resumo.objetivo),
          _item('Metodologia', resumo.metodologia),
          _item('Resultados', resumo.resultados),
          _item('Conclusão', resumo.conclusao),
        ],
      ),
    );
  }

  Widget _item(String t, String c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
      Text(c),
    ]),
  );
}