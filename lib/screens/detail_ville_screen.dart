import 'package:flutter/material.dart';
import 'package:flutterprojet/main.dart';
import 'package:flutterprojet/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutterprojet/models/ville.dart';
import 'package:flutterprojet/models/forecast.dart';
import 'package:flutterprojet/services/weather_service.dart';
import 'package:dio/dio.dart';

class DetailVilleScreen extends StatefulWidget {
  final Ville ville;

  const DetailVilleScreen({Key? key, required this.ville}) : super(key: key);

  @override
  _DetailVilleScreenState createState() => _DetailVilleScreenState();
}

class _DetailVilleScreenState extends State<DetailVilleScreen> {
  late WeatherService _weatherService;
  List<ForecastItem> _hourlyForecast = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _weatherService = WeatherService(Dio());
    _loadHourlyForecast();
  }

  // Charger les prévisions horaires
  Future<void> _loadHourlyForecast() async {
    try {
      final forecastResponse = await _weatherService.getForecast(
        widget.ville.cityName,
        "metric",
        Constants.openWeatherApiKey,
      );
      setState(() {
        _hourlyForecast = forecastResponse.list.take(4).toList(); // Prendre les 4 premières prévisions
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des prévisions : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Date actuelle formatée
    final String formattedDate = DateFormat('EEEE, dd MMM', 'fr_FR').format(DateTime.now());

    // Utilisation des vraies données de l'objet Ville
    final double temperature = widget.ville.temperature;
    final double feelsLike = widget.ville.feelsLike;
    final double tempMin = widget.ville.tempMin;
    final double tempMax = widget.ville.tempMax;
    final int humidity = widget.ville.humidity;
    final double windSpeed = widget.ville.windSpeed;

    // Coordonnées pour la Google Map
    final LatLng cityLocation = LatLng(widget.ville.latitude, widget.ville.longitude);


    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? [Colors.grey[800]!, Colors.grey[900]!]
        : [Colors.blue[500]!, Colors.blue[200]!];

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[800]!: Colors.blue[500]!,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.ville.cityName,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
                icon: Icon(
                  MyApp.of(context).isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  MyApp.of(context).toggleTheme();
                },
              ),
        ],

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section principale : Température, ressentie, vent, humidité et image météo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Détails textuels
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${temperature.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ressenti ${feelsLike.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vent: ${windSpeed.toStringAsFixed(0)} km/h',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Humidité: $humidity%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    // Image météo détaillée
                    Image.asset(
                      _mapDetailWeatherImage(widget.ville.icon),
                      width: 120,
                      height: 120,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Description météo (ex: Clear, Clouds, etc.)
                Text(
                  _mapWeatherDescription(widget.ville.icon),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // Section Air Quality (utilisez vos vraies données si disponibles)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qualité de l\'air',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _airQualityItem(title: 'Ressenti', value: '${feelsLike.toStringAsFixed(1)}°'),
                          _airQualityItem(title: 'Indice UV', value: 'N/A'),
                          _airQualityItem(title: 'SO2', value: 'N/A'),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _airQualityItem(title: 'Risque de pluie', value: 'N/A'),
                          _airQualityItem(title: 'Vent', value: '${windSpeed.toStringAsFixed(0)} km/h'),
                          _airQualityItem(title: 'O3', value: 'N/A'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Section "Aujourd'hui" avec prévisions horaires
                const Text(
                  'Aujourd\'hui',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 85,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : ListView(
                    scrollDirection: Axis.horizontal,
                    children: _hourlyForecast.map((forecast) {
                      final hour = DateFormat('HH:mm', 'fr_FR').format(DateTime.fromMillisecondsSinceEpoch(forecast.dt * 1000));
                      final icon = forecast.weather.first.main.toLowerCase();
                      final temp = forecast.main.temperature.toInt();
                      return _forecastHourItem(hour: hour, icon: icon, temp: temp);
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Google Map affichant la localisation exacte de la ville
                SizedBox(
                  height: 300,
                  // child: GoogleMap(
                  //   initialCameraPosition: CameraPosition(
                  //     target: cityLocation,
                  //     zoom: 12,
                  //   ),
                  //   markers: {
                  //     Marker(
                  //       markerId: MarkerId(widget.ville.cityName),
                  //       position: cityLocation,
                  //       infoWindow: InfoWindow(title: widget.ville.cityName),
                  //     )
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Conversion de l'icône (ville.icon) en image pour la vue détaillée
  String _mapDetailWeatherImage(String icon) {
    switch (icon) {
      case 'cloud':
        return 'assets/images/cloud_detail.png';
      case 'rain':
        return 'assets/images/rain_detail.png';
      case 'storm':
        return 'assets/images/storm_detail.png';
      default:
        return 'assets/images/sun01.png';
    }
  }

  // Mapping de l'icône en une description textuelle
  String _mapWeatherDescription(String icon) {
    switch (icon) {
      case 'cloud':
        return 'Nuageux';
      case 'rain':
        return 'Pluie';
      case 'storm':
        return 'Orage';
      default:
        return 'Dégagé';
    }
  }

  // Widget pour un élément de la section Air Quality
  Widget _airQualityItem({required String title, required String value}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }

  // Widget pour un élément de la prévision horaire "Aujoud'hui"
  Widget _forecastHourItem({required String hour, required String icon, required int temp}) {
    final String path = _mapDetailWeatherImage(icon);
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hour,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Image.asset(path, width: 35, height: 35),
          const SizedBox(height: 4),
          Text(
            '$temp°',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}