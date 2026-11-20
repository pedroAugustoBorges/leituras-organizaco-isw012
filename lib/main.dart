// Integrante: Pedro Augusto de Melo Borges
import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const OrganizacaoLeiturasApp());
}

class OrganizacaoLeiturasApp extends StatelessWidget {
  const OrganizacaoLeiturasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corFundo = Color(0xFFF7F7F2);

    return MaterialApp(
      title: 'Organização de Leituras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF557A65)),
        scaffoldBackgroundColor: corFundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: corFundo,
          foregroundColor: Color(0xFF1C2922),
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 72,
        ),
      ),
      home: const HomePage(),
    );
  }
}
