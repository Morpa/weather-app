import 'package:clean_tdd/core/constants/constants.dart';
import 'package:clean_tdd/core/error/exception.dart';
import 'package:clean_tdd/data/data_sources/weather_remote_data_source.dart';
import 'package:clean_tdd/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late WeatherRemoteDataSource weatherRemoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    weatherRemoteDataSource =
        WeatherRemoteDataSourceImpl(client: mockHttpClient);
  });

  const testCityName = 'Porto';

  group('get current weather', () {
    test('should return weather model when the response code is 200', () async {
      // ARRANGE
      when(mockHttpClient
              .get(Uri.parse(Urls.currentWeatherByName(testCityName))))
          .thenAnswer((_) async => http.Response(
                readJson('helpers/dummy_data/dummy_weather_response.json'),
                200,
              ));

      // ACT
      final result =
          await weatherRemoteDataSource.getCurrentWeather(testCityName);

      // ASSERT
      expect(result, isA<WeatherModel>());
    });

    test(
        'should throw a server exception when the response code is 404 or other',
        () async {
      // ARRANGE
      when(mockHttpClient
              .get(Uri.parse(Urls.currentWeatherByName(testCityName))))
          .thenAnswer((_) async => http.Response('Not found', 404));

      // ACT
      final result = weatherRemoteDataSource.getCurrentWeather(testCityName);

      // ASSERT
      expect(result, throwsA(isA<ServerException>()));
    });
  });
}
