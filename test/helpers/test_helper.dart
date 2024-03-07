import 'package:clean_tdd/data/data_sources/weather_remote_data_source.dart';
import 'package:clean_tdd/domain/repositories/weather_repository.dart';
import 'package:clean_tdd/domain/usecases/get_current_weather.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks(
  [
    WeatherRepository,
    WeatherRemoteDataSource,
    GetCurrentWeather,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
