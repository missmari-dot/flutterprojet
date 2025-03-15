import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojet/main.dart';
import 'package:flutterprojet/widgets/bottom_app_bar_widget.dart';
import 'package:flutterprojet/widgets/custom_radial_gauge.dart';
import 'package:flutterprojet/widgets/prevision_widget.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;
  bool _isLoading = true;

  final List<String> _cities = ["Dakar", "Paris", "New York", "Tokyo", "Sydney"];
  int _currentCityIndex = 0;

  Weather? _currentWeather;
  List<ForecastItem> _forecastItems = [];

  late WeatherService _weatherService;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Dio dio = Dio();
    _weatherService = WeatherService(dio, baseUrl: Constants.openWeatherBaseUrl);

    _fetchWeatherForCurrentCity();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {
        _progress = _controller.value;
      });
    });
    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _controller.reset();
      _controller.forward();
      _fetchWeatherForCurrentCity();
    });
  }

  Future<void> _fetchWeatherForCurrentCity() async {
    setState(() => _isLoading = true);
    String city = _cities[_currentCityIndex];

    try {
      final weather = await _weatherService.getWeather(
        city,
        "metric",
        Constants.openWeatherApiKey,
      );
      setState(() => _currentWeather = weather);
      await _fetchForecastForCity(city);
    } catch (e) {
      print("Erreur lors de la récupération des données pour $city: $e");
    }

    setState(() => _isLoading = false);

    _currentCityIndex = (_currentCityIndex + 1) % _cities.length;
  }

  Future<void> _fetchForecastForCity(String city) async {
    try {
      final forecastResponse = await _weatherService.getForecast(
        city,
        "metric",
        Constants.openWeatherApiKey,
      );
      setState(() {
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
    final temperature = _currentWeather?.main.temperature;
    final cityName = _currentWeather?.city;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [Colors.grey[800]!, Colors.grey[900]!]
        : [Colors.blue[500]!, Colors.blue[200]!];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Météo en Temps Réel',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        backgroundColor: isDark ? Colors.grey[800]!: Colors.blue[500]!,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // On appelle la méthode toggleTheme()
              MyApp.of(context).toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: const BottomPlus(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBarWidget(),

      body: Container(
        // Le gradient pourra s'adapter selon le thème
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
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
              // Jauge
              CustomRadialGauge(
                progress: _progress,
                size: 200,
                strokeWidth: 20,
                progressColor: Colors.blue[800]!,
                backgroundColor: Colors.white.withOpacity(0.20),
                temperature: temperature,
                city: cityName,
                maxTemperature: 50.0,
              ),
              const SizedBox(height: 20),
              // Espace, chargement, etc.
              const SizedBox(height: 40),
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
          _DayCard(day: 'Mardi', image: "assets/images/sun01.png", isToday: true),
          _DayCard(day: 'Merc..', image: "assets/images/nc03.png"),
          _DayCard(day: 'Jeudi', image: "assets/images/sun.png"),
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
          Image.asset(image, height: 60, width: 50),
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
