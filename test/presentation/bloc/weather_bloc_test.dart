import 'package:bloc_test/bloc_test.dart';
import 'package:clean_tdd/core/error/failure.dart';
import 'package:clean_tdd/domain/entities/weather.dart';
import 'package:clean_tdd/presentation/bloc/weather_bloc.dart';
import 'package:clean_tdd/presentation/bloc/weather_event.dart';
import 'package:clean_tdd/presentation/bloc/weather_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetCurrentWeather mockGetCurrentWeather;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeather();
    weatherBloc = WeatherBloc(mockGetCurrentWeather);
  });

  const testWeather = WeatherEntity(
    cityName: 'Porto',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 12.0,
    pressure: 1009,
    humidity: 75,
  );

  const testCityName = 'Porto';

  test('initial state should be empty', () {
    expect(weatherBloc.state, WeatherEmpty());
  });

  blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(mockGetCurrentWeather.execute(testCityName))
            .thenAnswer((_) async => const Right(testWeather));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
      wait: const Duration(milliseconds: 500),
      expect: () => [WeatherLoading(), const WeatherLoaded(testWeather)]);

  blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoadFailure] when get data is unsuccessful',
      build: () {
        when(mockGetCurrentWeather.execute(testCityName)).thenAnswer(
            (_) async => const Left(ServerFailure('Server failure')));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const OnCityChanged(testCityName)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            WeatherLoading(),
            const WeatherLoadFailure('Server failure'),
          ]);
}
