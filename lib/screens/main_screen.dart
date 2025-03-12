import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojet/widgets/custom_radial_gauge.dart';
import 'package:flutterprojet/widgets/loading_message.dart';
import 'package:flutterprojet/widgets/prevision_widget.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;
  bool _isLoading = true;

  // Liste de villes à parcourir
  final List<String> _cities = ["Dakar", "Paris", "New York", "Tokyo", "Sydney"];
  int _currentCityIndex = 0;

  // Données météo et prévisions récupérées
  Weather? _currentWeather;
  List<ForecastItem> _forecastItems = [];

  // Service API
  late WeatherService _weatherService;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Initialisation de Dio et du service Retrofit avec le baseUrl complet
    Dio dio = Dio();
    _weatherService = WeatherService(dio, baseUrl: Constants.openWeatherBaseUrl);

    // Premier appel API pour la ville courante
    _fetchWeatherForCurrentCity();

    // Animation de 5 secondes pour la jauge
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {
        _progress = _controller.value;
      });
    });
    _controller.forward();

    // Toutes les 5 secondes, récupérer la météo (et le forecast) pour la ville suivante
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _controller.reset();
      _controller.forward();
      _fetchWeatherForCurrentCity();
    });
  }

  Future<void> _fetchWeatherForCurrentCity() async {
    setState(() {
      _isLoading = true;
    });

    String city = _cities[_currentCityIndex];

    try {
      // Récupération de la météo actuelle
      final weather = await _weatherService.getWeather(
          city, "metric", Constants.openWeatherApiKey);
      setState(() {
        _currentWeather = weather;
      });
      // Récupération des prévisions pour la même ville
      await _fetchForecastForCity(city);
    } catch (e) {
      print("Erreur lors de la récupération des données pour $city: $e");
    }

    setState(() {
      _isLoading = false;
    });

    // Passer à la ville suivante
    _currentCityIndex = (_currentCityIndex + 1) % _cities.length;
  }

  Future<void> _fetchForecastForCity(String city) async {
    try {
      final forecastResponse = await _weatherService.getForecast(
          city, "metric", Constants.openWeatherApiKey);
      setState(() {
        // Ici, nous prenons les 3 premiers éléments de la réponse
        _forecastItems = forecastResponse.list.take(3).toList();
      });
    } catch (e) {
      print("Erreur lors de la récupération du forecast pour $city: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pour la jauge, on affiche la température récupérée (ou un placeholder)
    final temperature = _currentWeather?.main.temperature;
    final cityName = _currentWeather?.city;

    return Scaffold(
      appBar: AppBar(
        title: Text('Météo en Temps Réel'),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
      ),
      bottomNavigationBar: _buildBottomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.blue[800]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 40),

              _buildTopDaysSection(),

              const SizedBox(height: 50),

              // Jauge de progression animée avec données réelles
            CustomRadialGauge(
              progress: _progress, // Supprimez cette ligne, car la progression est maintenant calculée en interne
              size: 200,
              strokeWidth: 20,
              backgroundColor: Colors.blue,
              progressColor: Colors.white,
              temperature: temperature, // Température récupérée
              city: cityName, // Nom de la ville
              maxTemperature: 50.0, // Température maximale (ajustez selon vos besoins)
            ),

              const SizedBox(height: 20),

              // Message d'attente pendant le chargement
              if (_isLoading) LoadingMessage(),
              const SizedBox(height: 40),

              // Affichage de la liste de prévisions réelle
              // _buildBottomForecastList(),

              PrevisionWidget(forecastItems: _forecastItems),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopDaysSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DayCard(day: 'Lundi', image: "assets/images/nc03.png"),
          _DayCard(day: 'Mardi', image: "assets/images/nc03.png", isToday: true),
          _DayCard(day: 'Merc..', image: "assets/images/nc03.png"),
          _DayCard(day: 'Jeudi', image: "assets/images/nc03.png"),
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white.withOpacity(0.2),
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.blue),
            onPressed: () {},
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String day;
  final String image;
  final bool isToday;

  const _DayCard({
    Key? key,
    required this.day,
    required this.image,
    this.isToday = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isToday ? const Color(0xFF00ACC1) : Colors.black87;
    return Container(
      width: 80,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 60,
            width: 50,
          ),
          const SizedBox(height: 2),
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}




