import 'package:clean_tdd/domain/entities/weather.dart';
import 'package:clean_tdd/domain/usecases/get_current_weather.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetCurrentWeather getCurrentWeather;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeather = GetCurrentWeather(mockWeatherRepository);
  });

  const testWeatherDetail = WeatherEntity(
    cityName: 'Porto',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 12.0,
    pressure: 1009,
    humidity: 75,
  );

  const testCityName = 'Porto';

  test('should get current weather detail from the repository', () async {
    // ARRANGE
    when(mockWeatherRepository.getCurrentWeather(testCityName))
        .thenAnswer((_) async => const Right(testWeatherDetail));

    // ACT
    final result = await getCurrentWeather.execute(testCityName);

    // ASSERT
    expect(result, const Right(testWeatherDetail));
  });
}
