# Organização de Leituras

Aplicativo desenvolvido em Flutter e Dart para organizar uma lista pessoal de livros e acompanhar o andamento das leituras.

## Funcionalidades

- Cadastrar livro com título e autor.
- Escolher entre os status **Quero ler**, **Lendo** e **Concluído**.
- Consultar os livros cadastrados na tela inicial.
- Remover livros com confirmação.
- Receber mensagens de confirmação ao adicionar ou remover livros.
- Manter a lista salva localmente entre as execuções do aplicativo.

## Persistência dos dados

O aplicativo usa o pacote **shared_preferences**. Como esse armazenamento funciona com pares de chave e valor, a coleção de livros é convertida para JSON e salva como uma única string na chave **livros**. Ao iniciar o app, essa string é lida e convertida novamente para a lista de livros.

O projeto não usa SQLite nem banco de dados externo.

## Como executar

Com o Flutter instalado, na pasta do projeto execute:

~~~sh
flutter pub get
flutter run
~~~

## Integrante

Pedro Augusto de Melo Borges

## Estrutura principal

- lib/models/livro.dart: dados do livro e status de leitura.
- lib/screens/home_page.dart: lista e ações da tela inicial.
- lib/screens/cadastro_livro_page.dart: formulário de cadastro.
- lib/services/livro_storage.dart: gravação e leitura local.

## Referências

- [Pacote shared_preferences](https://pub.dev/packages/shared_preferences)
- [Navegação entre telas no Flutter](https://docs.flutter.dev/cookbook/navigation/navigation-basics)
