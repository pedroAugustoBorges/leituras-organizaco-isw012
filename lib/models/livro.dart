// Integrante: Pedro Augusto de Melo Borges

enum StatusLeitura {
  queroLer('Quero ler'),
  lendo('Lendo'),
  concluido('Concluído');

  const StatusLeitura(this.nomeExibicao);

  final String nomeExibicao;
}

class Livro {
  const Livro({
    required this.titulo,
    required this.autor,
    required this.status,
  });

  final String titulo;
  final String autor;
  final StatusLeitura status;
}
