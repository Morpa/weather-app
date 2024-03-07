import 'package:clean_tdd/domain/repositories/weather_repository.dart';
import 'package:clean_tdd/domain/usecases/get_current_weather.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks(
  [
    WeatherRepository,
    GetCurrentWeather,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
