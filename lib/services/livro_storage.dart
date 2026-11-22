// Integrante: Pedro Augusto de Melo Borges
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/livro.dart';

class LivroStorage {
  LivroStorage({SharedPreferencesAsync? preferencias})
    : _preferencias = preferencias ?? SharedPreferencesAsync();

  static const _chaveLivros = 'livros';

  final SharedPreferencesAsync _preferencias;

  Future<List<Livro>> carregarLivros() async {
    final jsonSalvo = await _preferencias.getString(_chaveLivros);

    if (jsonSalvo == null || jsonSalvo.isEmpty) {
      return [];
    }

    try {
      final dados = jsonDecode(jsonSalvo);
      if (dados is! List) {
        return [];
      }

      final livros = <Livro>[];
      for (final item in dados) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        try {
          livros.add(Livro.fromJson(item));
        } on FormatException {
          continue;
        }
      }

      return livros;
    } on FormatException {
      return [];
    }
  }

  Future<void> salvarLivros(List<Livro> livros) async {
    final json = jsonEncode(livros.map((livro) => livro.toJson()).toList());
    await _preferencias.setString(_chaveLivros, json);
  }
}
