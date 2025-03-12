import 'package:json_annotation/json_annotation.dart';
import 'weather.dart';

part 'forecast.g.dart';

@JsonSerializable()
class ForecastResponse {
  final List<ForecastItem> list;

  ForecastResponse({required this.list});

  factory ForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastResponseToJson(this);
}

@JsonSerializable()
class ForecastItem {
  final int dt;
  final MainWeather main;
  final List<WeatherDescription> weather;
  @JsonKey(name: 'dt_txt')
  final String dtTxt;

  ForecastItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) =>
      _$ForecastItemFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastItemToJson(this);
}

@JsonSerializable()
class WeatherDescription {
  final String main;
  final String description;
  final String icon;

  WeatherDescription({
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDescription.fromJson(Map<String, dynamic> json) =>
      _$WeatherDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDescriptionToJson(this);
}
