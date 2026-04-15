import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfs;
import 'package:share_plus/share_plus.dart';
import 'modelos.dart';

class PdfUtil {
  static Future<void> compartilharResumo(Resumo r) async {
    final pdf = pdfs.Document();
    pdf.addPage(pdfs.Page(build: (context) => pdfs.Column(children: [
      pdfs.Text(r.titulo, style: pdfs.TextStyle(fontSize: 24, fontWeight: pdfs.FontWeight.bold)),
      pdfs.Divider(),
      pdfs.Text('Objetivo: ${r.objetivo}'),
      pdfs.Text('Metodologia: ${r.metodologia}'),
      pdfs.Text('Resultados: ${r.resultados}'),
      pdfs.Text('Conclusão: ${r.conclusao}'),
    ])));

    final pasta = await getTemporaryDirectory();
    final arquivo = File('${pasta.path}/resumo.pdf');
    await arquivo.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(arquivo.path)], text: 'Meu Resumo: ${r.titulo}');
  }
}