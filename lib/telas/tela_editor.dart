import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../api.dart';
import '../modelos.dart';

class TelaEditor extends StatefulWidget {
  const TelaEditor({super.key});
  @override
  State<TelaEditor> createState() => _TelaEditorState();
}

class _TelaEditorState extends State<TelaEditor> {
  final _controller = TextEditingController();
  bool _carregando = false;
  bool _extraindoPdf = false;

  Future<void> _anexarPdf() async {
    final resultado = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (resultado == null || resultado.files.single.path == null) return;

    setState(() => _extraindoPdf = true);

    try {
      final bytes = await File(resultado.files.single.path!).readAsBytes();
      final documento = PdfDocument(inputBytes: bytes);
      final texto = PdfTextExtractor(documento).extractText();
      documento.dispose();

      if (texto.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PDF sem texto selecionável (pode ser escaneado).')),
          );
        }
        return;
      }

      setState(() => _controller.text = texto);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao ler o PDF: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _extraindoPdf = false);
    }
  }

  void _gerar() async {
    if (_controller.text.isEmpty) return;
    setState(() => _carregando = true);
    try {
      final resumo = await gerarResumoIA(_controller.text);
      await RepositorioResumos().salvar(resumo);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/leitura', arguments: resumo);
      }
    } catch (e) {
      debugPrint("Erro no Editor: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Resumo'),
        actions: [
          _extraindoPdf
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  tooltip: 'Anexar PDF',
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: _carregando ? null : _anexarPdf,
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: TextField(controller: _controller, maxLines: null, decoration: const InputDecoration(hintText: 'Cole seu texto ou anexe um PDF...'))),
            const SizedBox(height: 16),
            _carregando ? const CircularProgressIndicator() : ElevatedButton(onPressed: _gerar, child: const Text('GERAR')),
          ],
        ),
      ),
    );
  }
}
