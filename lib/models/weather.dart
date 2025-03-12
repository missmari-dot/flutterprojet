import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  // Le nom de la ville (renvoyé dans "name")
  @JsonKey(name: 'name')
  final String city;

  // La température (renvoyée dans "main.temp")
  @JsonKey(name: 'main')
  final MainWeather main;

  Weather({
    required this.city,
    required this.main,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class MainWeather {
  @JsonKey(name: 'temp')
  final double temperature;

  MainWeather({
    required this.temperature,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) =>
      _$MainWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$MainWeatherToJson(this);
}
