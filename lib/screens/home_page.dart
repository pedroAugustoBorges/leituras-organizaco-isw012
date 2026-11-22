// Integrante: Pedro Augusto de Melo Borges
import 'package:flutter/material.dart';

import '../models/livro.dart';
import '../services/livro_storage.dart';
import 'cadastro_livro_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Livro> _livros = [];
  final LivroStorage _armazenamento = LivroStorage();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    try {
      final livrosSalvos = await _armazenamento.carregarLivros();
      if (!mounted) {
        return;
      }

      setState(() {
        _livros
          ..clear()
          ..addAll(livrosSalvos);
        _carregando = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() => _carregando = false);
      _mostrarMensagem('Não foi possível carregar os livros salvos.');
    }
  }

  Future<bool> _salvarLivros() async {
    try {
      await _armazenamento.salvarLivros(List<Livro>.unmodifiable(_livros));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _abrirCadastro() async {
    final livro = await Navigator.of(context).push<Livro>(
      MaterialPageRoute<Livro>(builder: (context) => const CadastroLivroPage()),
    );

    if (!mounted || livro == null) {
      return;
    }

    setState(() => _livros.add(livro));
    final salvo = await _salvarLivros();
    if (!mounted) {
      return;
    }

    _mostrarMensagem(
      salvo
          ? 'Livro adicionado à sua biblioteca.'
          : 'Livro adicionado, mas não foi possível salvar os dados.',
    );
  }

  Future<void> _confirmarRemocao(Livro livro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover livro?'),
        content: Text('Deseja remover "${livro.titulo}" da sua lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Remover'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) {
      return;
    }

    setState(() => _livros.remove(livro));
    final salvo = await _salvarLivros();
    if (!mounted) {
      return;
    }

    _mostrarMensagem(
      salvo
          ? 'Livro removido da sua biblioteca.'
          : 'Livro removido da tela, mas não foi possível salvar os dados.',
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensagem), behavior: SnackBarBehavior.floating),
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
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                    (livro) =>
                        _BookCard(livro: livro, onRemover: _confirmarRemocao),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _carregando ? null : _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar livro'),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.livro, required this.onRemover});

  final Livro livro;
  final ValueChanged<Livro> onRemover;

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
        trailing: IconButton(
          onPressed: () => onRemover(livro),
          tooltip: 'Remover ${livro.titulo}',
          color: cores.error,
          icon: const Icon(Icons.delete_outline),
        ),
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
