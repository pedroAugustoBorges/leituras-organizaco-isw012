import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizao_leituras/models/livro.dart';
import 'package:organizao_leituras/screens/cadastro_livro_page.dart';

void main() {
  testWidgets('formulário informa campos, status e valida dados', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroLivroPage()));

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Quero ler'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<StatusLeitura>));
    await tester.pumpAndSettle();

    expect(find.text('Lendo'), findsOneWidget);
    expect(find.text('Concluído'), findsOneWidget);

    await tester.tap(find.text('Lendo'));
    await tester.pumpAndSettle();
    expect(find.text('Lendo'), findsOneWidget);

    await tester.tap(find.text('Adicionar livro'));
    await tester.pumpAndSettle();

    expect(find.text('Informe o título do livro.'), findsOneWidget);
    expect(find.text('Informe o autor do livro.'), findsOneWidget);
  });
}
