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

  Map<String, Object?> toJson() => {
    'titulo': titulo,
    'autor': autor,
    'status': status.name,
  };

  factory Livro.fromJson(Map<String, dynamic> json) {
    final titulo = json['titulo'];
    final autor = json['autor'];

    if (titulo is! String || autor is! String) {
      throw const FormatException('Dados do livro inválidos.');
    }

    final statusSalvo = json['status'];
    final status = StatusLeitura.values.firstWhere(
      (opcao) => opcao.name == statusSalvo,
      orElse: () => StatusLeitura.queroLer,
    );

    return Livro(titulo: titulo, autor: autor, status: status);
  }
}
