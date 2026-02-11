import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const JanSaarthiApp());
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
