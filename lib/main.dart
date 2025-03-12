import 'package:flutter/material.dart';
import 'package:flutterprojet/screens/main_screen.dart';
import 'screens/home_screen.dart'; // Importez l'écran d'accueil

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo en Temps Réel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      routes: {
        '/main': (context) => MainScreen(),
      },
    );
  }
}