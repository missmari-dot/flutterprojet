import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  @JsonKey(name: 'coord')
  final Coord coord;

  @JsonKey(name: 'name')
  final String city;

  @JsonKey(name: 'sys')
  final Sys sys;

  @JsonKey(name: 'main')
  final MainWeather main;

  @JsonKey(name: 'wind')
  final Wind wind;

  @JsonKey(name: 'weather')
  final List<WeatherCondition> conditions;

  Weather({
    required this.coord,
    required this.city,
    required this.sys,
    required this.main,
    required this.wind,
    required this.conditions,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@JsonSerializable()
class Sys {
  @JsonKey(name: 'country')
  final String country;

  Sys({required this.country});

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
  Map<String, dynamic> toJson() => _$SysToJson(this);
}

@JsonSerializable()
class MainWeather {
  @JsonKey(name: 'temp')
  final double temperature;

  @JsonKey(name: 'feels_like')
  final double feelsLike;

  @JsonKey(name: 'temp_min')
  final double tempMin;

  @JsonKey(name: 'temp_max')
  final double tempMax;

  @JsonKey(name: 'humidity')
  final int humidity;

  MainWeather({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
  });

  factory MainWeather.fromJson(Map<String, dynamic> json) =>
      _$MainWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$MainWeatherToJson(this);
}

@JsonSerializable()
class Wind {
  final double speed;
  final int deg; // degrés

  Wind({
    required this.speed,
    required this.deg,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
  Map<String, dynamic> toJson() => _$WindToJson(this);
}

@JsonSerializable()
class WeatherCondition {
  final String main;        // ex: "Clouds", "Clear", "Rain"
  final String description; // ex: "clear sky"
  final String icon;        // ex: "01d"

  WeatherCondition({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherConditionToJson(this);
}
