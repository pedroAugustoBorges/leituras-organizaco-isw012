// Integrante: Pedro Augusto de Melo Borges
import 'package:flutter/material.dart';

import '../models/livro.dart';

class CadastroLivroPage extends StatefulWidget {
  const CadastroLivroPage({super.key});

  @override
  State<CadastroLivroPage> createState() => _CadastroLivroPageState();
}

class _CadastroLivroPageState extends State<CadastroLivroPage> {
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();

  StatusLeitura _statusSelecionado = StatusLeitura.queroLer;
  String? _erroTitulo;
  String? _erroAutor;

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  void _salvarLivro() {
    final titulo = _tituloController.text.trim();
    final autor = _autorController.text.trim();

    setState(() {
      _erroTitulo = titulo.isEmpty ? 'Informe o título do livro.' : null;
      _erroAutor = autor.isEmpty ? 'Informe o autor do livro.' : null;
    });

    if (_erroTitulo != null || _erroAutor != null) {
      return;
    }

    FocusScope.of(context).unfocus();
    Navigator.of(context)
        .pop(Livro(titulo: titulo, autor: autor, status: _statusSelecionado));
  }

  InputDecoration _decoracaoCampo({
    required String rotulo,
    required String dica,
    required IconData icone,
    String? erro,
  }) {
    return InputDecoration(
      labelText: rotulo,
      hintText: dica,
      errorText: erro,
      prefixIcon: Icon(icone),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Novo livro',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Pedro Augusto de Melo Borges',
              style: tema.textTheme.labelSmall?.copyWith(
                color: cores.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
          children: [
            Text(
              'Adicione à sua biblioteca',
              style: tema.textTheme.headlineSmall?.copyWith(
                color: cores.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Informe os dados do livro e escolha o status da leitura.',
              style: tema.textTheme.bodyLarge?.copyWith(
                color: cores.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _tituloController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              onChanged: (valor) {
                if (_erroTitulo != null && valor.trim().isNotEmpty) {
                  setState(() => _erroTitulo = null);
                }
              },
              decoration: _decoracaoCampo(
                rotulo: 'Título',
                dica: 'Ex.: O pequeno príncipe',
                icone: Icons.menu_book_outlined,
                erro: _erroTitulo,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _autorController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _salvarLivro(),
              onChanged: (valor) {
                if (_erroAutor != null && valor.trim().isNotEmpty) {
                  setState(() => _erroAutor = null);
                }
              },
              decoration: _decoracaoCampo(
                rotulo: 'Autor',
                dica: 'Ex.: Antoine de Saint-Exupéry',
                icone: Icons.person_outline,
                erro: _erroAutor,
              ),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<StatusLeitura>(
              initialValue: _statusSelecionado,
              decoration: _decoracaoCampo(
                rotulo: 'Status da leitura',
                dica: 'Selecione um status',
                icone: Icons.bookmark_outline,
              ),
              items: StatusLeitura.values
                  .map(
                    (status) => DropdownMenuItem<StatusLeitura>(
                      value: status,
                      child: Text(status.nomeExibicao),
                    ),
                  )
                  .toList(),
              onChanged: (status) {
                if (status != null) {
                  setState(() => _statusSelecionado = status);
                }
              },
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _salvarLivro,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar livro'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
