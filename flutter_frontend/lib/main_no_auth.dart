import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen_production.dart';

void main() {
  runApp(const ProviderScope(child: JanSaarthiApp()));
}

class JanSaarthiApp extends StatelessWidget {
  const JanSaarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JanSaarthi AI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B5CE7),
          primary: const Color(0xFF6B5CE7),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6B5CE7),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
