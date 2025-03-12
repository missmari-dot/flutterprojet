import 'package:flutter/material.dart';
import '../models/forecast.dart'; // Assurez-vous d'importer le modèle ForecastItem

class PrevisionWidget extends StatelessWidget {
  final List<ForecastItem> forecastItems;

  const PrevisionWidget({required this.forecastItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: forecastItems.map((forecast) {
        return _ForecastItem(
          icon: _getWeatherIcon(forecast.weather.first.main),
          iconColor: _getWeatherColor(forecast.weather.first.main),
          title: "${forecast.main.temperature.toStringAsFixed(1)}°C",
          subtitle: forecast.dtTxt,
        );
      }).toList(),
    );
  }

  // Méthode pour obtenir une icône en fonction de la météo
  IconData _getWeatherIcon(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Méthode pour obtenir une couleur en fonction de la météo
  Color _getWeatherColor(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.grey;
      case 'rain':
        return Colors.blue;
      case 'snow':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }
}

class _ForecastItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ForecastItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}