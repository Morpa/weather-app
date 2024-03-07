import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';

final class WeatherRepositoryImpl implements WeatherRepository {
  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName) {
    // TODO: implement getCurrentWeather
    throw UnimplementedError();
  }
}
