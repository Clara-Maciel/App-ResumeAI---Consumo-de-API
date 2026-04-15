import 'package:flutter/material.dart';
import '../modelos.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});
  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  final repo = RepositorioResumos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Resumos'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<Resumo>>(
        future: repo.buscarTodos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final itens = snapshot.data!;
          if (itens.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nenhum resumo salvo ainda. Toque no botao + para criar o primeiro.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: itens.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(itens[i].titulo),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  Navigator.pushNamed(context, '/leitura', arguments: itens[i]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/editor').then((_) => setState(() {})),
        child: const Icon(Icons.add),
      ),
    );
  }
}
