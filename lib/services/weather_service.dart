import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../utils/constants.dart';

part 'weather_service.g.dart';

@RestApi(baseUrl: Constants.openWeatherBaseUrl)
abstract class WeatherService {
  factory WeatherService(Dio dio, {String baseUrl}) = _WeatherService;

  @GET("/weather")
  Future<Weather> getWeather(
      @Query("q") String city,
      @Query("units") String units,
      @Query("appid") String apiKey,
      );

  @GET("/forecast")
  Future<ForecastResponse> getForecast(
      @Query("q") String city,
      @Query("units") String units,
      @Query("appid") String apiKey,
      );
}
