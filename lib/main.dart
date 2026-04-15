import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import 'telas/tela_inicio.dart';
import 'telas/tela_editor.dart';
import 'telas/tela_leitura.dart';
import 'telas/tela_abertura.dart'; 
import 'telas/tela_login.dart';
 

import 'modelos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    if (dotenv.env['GEMINI_API_KEY'] == null || dotenv.env['GEMINI_API_KEY']!.isEmpty) {
      debugPrint("Erro: Chave GEMINI_API_KEY não encontrada no arquivo .env");
    }
  } catch (e) {
    debugPrint("Erro ao carregar o arquivo .env: $e");
  }
  runApp(const ResumeAiApp());
}

class ResumeAiApp extends StatelessWidget {
  const ResumeAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResumeAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaAbertura(),
        '/login': (context) => const TelaLogin(),
        '/home': (context) => const TelaInicio(),
        '/editor': (context) => const TelaEditor(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/leitura') {
          final resumo = settings.arguments;
          if (resumo == null || resumo is! Resumo) {
            return MaterialPageRoute(builder: (context) => const TelaInicio());
          }
          return MaterialPageRoute(
            builder: (context) => TelaLeitura(resumo: resumo),
          );
        }
        return null;
      },
    );
  }
}
