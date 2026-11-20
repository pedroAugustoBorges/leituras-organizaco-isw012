// Integrante: Pedro Augusto de Melo Borges
import 'package:flutter/material.dart';

import '../models/livro.dart';
import 'cadastro_livro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Livro> _livros = [];

  Future<void> _abrirCadastro() async {
    final livro = await Navigator.of(context).push<Livro>(
      MaterialPageRoute<Livro>(
        builder: (context) => const CadastroLivroPage(),
      ),
    );

    if (!mounted || livro == null) {
      return;
    }

    setState(() => _livros.add(livro));
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
              'Organização de Leituras',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
        children: [
          Text(
            'Sua biblioteca',
            style: tema.textTheme.headlineSmall?.copyWith(
              color: cores.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Organize seus livros e acompanhe cada etapa da leitura.',
            style: tema.textTheme.bodyLarge?.copyWith(
              color: cores.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),
          if (_livros.isEmpty)
            const _EmptyLibraryCard()
          else
            ..._livros.map(
              (livro) => _BookCard(livro: livro),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar livro'),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.livro});

  final Livro livro;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cores.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: cores.primaryContainer,
          foregroundColor: cores.onPrimaryContainer,
          child: const Icon(Icons.menu_book_outlined),
        ),
        title: Text(
          livro.titulo,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(livro.autor),
              const SizedBox(height: 10),
              Chip(
                label: Text(livro.status.nomeExibicao),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _EmptyLibraryCard extends StatelessWidget {
  const _EmptyLibraryCard();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cores.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cores.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_outlined,
              color: cores.onPrimaryContainer,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sua lista ainda está vazia',
            textAlign: TextAlign.center,
            style: tema.textTheme.titleMedium?.copyWith(
              color: cores.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Os livros que você cadastrar vão aparecer aqui.',
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: cores.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
