import 'dart:io';

import 'package:clean_tdd/core/error/exception.dart';
import 'package:clean_tdd/core/error/failure.dart';
import 'package:clean_tdd/data/models/weather_model.dart';
import 'package:clean_tdd/data/repositories/weather_repository_impl.dart';
import 'package:clean_tdd/domain/entities/weather.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  late WeatherRepositoryImpl weatherRepositoryImpl;

  setUp(() {
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    weatherRepositoryImpl = WeatherRepositoryImpl(
      weatherRemoteDataSource: mockWeatherRemoteDataSource,
    );
  });

  const testWeatherModel = WeatherModel(
    cityName: 'Porto',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 12.0,
    pressure: 1009,
    humidity: 75,
  );

  const testWeatherEntity = WeatherEntity(
    cityName: 'Porto',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 12.0,
    pressure: 1009,
    humidity: 75,
  );

  const testCityName = 'Porto';

  group('get current weather', () {
    test(
      'should return current weather when a call to data source is successful',
      () async {
        // ARRANGE
        when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
            .thenAnswer((_) async => testWeatherModel);

        // ACT
        final result =
            await weatherRepositoryImpl.getCurrentWeather(testCityName);

        // ASSERT
        expect(result, equals(const Right(testWeatherEntity)));
      },
    );

    test(
      'should return server failure when a call to data source is unsuccessful',
      () async {
        // ARRANGE
        when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
            .thenThrow(ServerException());

        // ACT
        final result =
            await weatherRepositoryImpl.getCurrentWeather(testCityName);

        // ASSERT
        expect(
            result, equals(const Left(ServerFailure('An error has occurred'))));
      },
    );

    test(
      'should return connection failure when the device has no internet',
      () async {
        // ARRANGE
        when(mockWeatherRemoteDataSource.getCurrentWeather(testCityName))
            .thenThrow(
                const SocketException('Failed to connect to the network'));

        // ACT
        final result =
            await weatherRepositoryImpl.getCurrentWeather(testCityName);

        // ASSERT
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });
}
