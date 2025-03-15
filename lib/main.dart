import 'package:flutter/material.dart';
import 'package:flutterprojet/screens/home_screen.dart';
import 'package:flutterprojet/screens/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Méthode statique pour récupérer l'état et ainsi basculer le thème
  static _MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>()!;
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo en Temps Réel',

      // ------------------ THEME CLAIR ------------------
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,  // Couleur principale
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Personnalisez ici les couleurs de base pour le mode clair
        scaffoldBackgroundColor: Colors.blue[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[500],
          foregroundColor: Colors.white,
        ),
        // Par exemple, un TextTheme custom
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),

      // ------------------ THEME SOMBRE ------------------
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Exemples de couleurs personnalisées
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[900],

        // Couleur de l'AppBar en mode sombre
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
        ),

        // Pour les Cards, Containers, etc.
        cardColor: Colors.grey[800],

        // Exemples d'adaptation de la colorScheme
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.tealAccent,
        ).copyWith(
          surface: Colors.grey[800],
        ),

        // Personnaliser la police du texte en mode sombre
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),

      // Bascule entre clair et sombre selon isDarkMode
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: HomeScreen(),
      routes: {
        '/main': (context) => MainScreen(),
      },
    );
  }
}
