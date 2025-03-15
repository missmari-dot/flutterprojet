import 'weather.dart';

class Ville {
  final String cityName;
  final String country;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String icon;
  final double latitude;
  final double longitude;

  Ville({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.latitude,
    required this.longitude,
  });

  // Conversion depuis un objet Weather
  factory Ville.fromWeather(Weather weather) {
    String mainCondition = 'Clear';
    if (weather.conditions.isNotEmpty) {
      mainCondition = weather.conditions.first.main;
    }
    return Ville(
      cityName: weather.city,
      country: weather.sys.country,
      temperature: weather.main.temperature,
      tempMin: weather.main.tempMin,
      tempMax: weather.main.tempMax,
      feelsLike: weather.main.feelsLike,
      humidity: weather.main.humidity,
      windSpeed: weather.wind.speed,
      icon: _chooseIcon(mainCondition),
      latitude: weather.coord.lat,
      longitude: weather.coord.lon,
    );
  }

  // Méthode privée pour mapper "mainCondition" en mot-clé (sun, cloud, etc.)
  static String _chooseIcon(String mainCondition) {
    final lower = mainCondition.toLowerCase();
    if (lower.contains('rain')) {
      return 'rain';
    } else if (lower.contains('storm') || lower.contains('thunder')) {
      return 'storm';
    } else if (lower.contains('cloud')) {
      return 'cloud';
    } else {
      return 'sun';
    }
  }
}
